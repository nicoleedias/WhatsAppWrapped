//
//  GeminiPhraseGenerator.swift
//  WhatsAppWrapped
//
//  Implementação do `SlidePhraseGenerator` com o Gemini (Firebase AI Logic):
//  tentativas, troca de modelo, limite de tempo e leitura do JSON de resposta.
//

import FirebaseAILogic
import Foundation
import os

/// Gera as frases com o Gemini pelo Firebase AI Logic (a chave da API fica no Firebase, não no app).
nonisolated struct GeminiPhraseGenerator: SlidePhraseGenerator {
    /// Tentativas em ordem. Se o primeiro modelo estiver sobrecarregado, tenta de novo e depois troca de modelo;
    /// se ele estiver lento (timeout), troca direto.
    var attempts = ["gemini-3.8-flash", "gemini-3.8-flash", "gemini-3.5-flash-lite"]
    /// Sem limite, o Firebase espera até 180 s por resposta.
    var timeoutPerAttempt: TimeInterval = 15
    /// Depois disso o app desiste e usa as frases prontas.
    var totalTimeout: Duration = .seconds(40)

    enum GeneratorError: Error {
        case emptyResponse
        case timedOut
    }

    private static let logger = Logger(subsystem: "WhatsAppWrapped", category: "Gemini")

    func phrases(for stats: WrappedStats, slides: [PhraseSlide]) async throws -> SlidePhrases {
        let message = try PhrasePrompt.userMessage(for: stats, slides: slides)

        return try await withThrowingTaskGroup(of: SlidePhrases.self) { group in
            group.addTask { try await generateWithRetries(message, slides: slides) }
            group.addTask {
                try await Task.sleep(for: totalTimeout)
                throw GeneratorError.timedOut
            }
            defer { group.cancelAll() }
            return try await group.next()!
        }
    }

    private func generateWithRetries(_ message: String, slides: [PhraseSlide]) async throws -> SlidePhrases {
        var lastError: any Error = GeneratorError.emptyResponse
        var skippedModels = Set<String>()
        for (index, modelName) in attempts.enumerated() where !skippedModels.contains(modelName) {
            if index > 0 { try await Task.sleep(for: .seconds(index)) }
            do {
                return try await generate(message, slides: slides, modelName: modelName)
            } catch {
                // Ex.: 500 "high demand", que costuma passar em poucos segundos.
                Self.logger.error("Gemini \(modelName) falhou na tentativa \(index + 1): \(error)")
                lastError = error
                // Cota esgotada não volta em segundos, e um modelo lento gastaria outro timeout inteiro:
                // nos dois casos vale mais ir para o próximo modelo.
                if Self.isQuotaExceeded(error) || Self.isTimeout(error) { skippedModels.insert(modelName) }
            }
        }
        throw lastError
    }

    /// Erro 429. O SDK não expõe o código HTTP, então ele é lido da descrição do erro.
    private static func isQuotaExceeded(_ error: any Error) -> Bool {
        String(describing: error).contains("httpResponseCode: 429")
    }

    /// A requisição passou de `timeoutPerAttempt` sem resposta.
    private static func isTimeout(_ error: any Error) -> Bool {
        guard case let GenerateContentError.internalError(underlying) = error else { return false }
        return (underlying as NSError).code == NSURLErrorTimedOut
    }

    private func generate(_ message: String, slides: [PhraseSlide], modelName: String) async throws -> SlidePhrases {
        let phraseSchema = Schema.object(properties: [
            "emoji": .string(description: "Um único emoji"),
            "text": .string(description: "Frase de até \(SlidePhrase.maximumLength) caracteres"),
        ])
        let responseSchema = Schema.object(
            properties: Dictionary(uniqueKeysWithValues: slides.map { ($0.rawValue, phraseSchema) })
        )

        let model = FirebaseAI.firebaseAI(backend: .googleAI()).generativeModel(
            modelName: modelName,
            // Modelos Gemini 3 não aceitam temperatura; a variedade vem das regras do prompt.
            // Frases curtas não precisam de muito raciocínio, e menos raciocínio responde mais rápido.
            generationConfig: GenerationConfig(
                responseMIMEType: "application/json",
                responseSchema: responseSchema,
                thinkingConfig: ThinkingConfig(thinkingLevel: .low)
            ),
            systemInstruction: ModelContent(role: "system", parts: PhrasePrompt.systemInstruction),
            requestOptions: RequestOptions(timeout: timeoutPerAttempt)
        )

        let response = try await model.generateContent(message)
        guard let json = response.text?.data(using: .utf8) else { throw GeneratorError.emptyResponse }

        let decoded = try JSONDecoder().decode([String: SlidePhrase].self, from: json)
        return SlidePhrases(Dictionary(uniqueKeysWithValues: decoded.compactMap { key, phrase in
            PhraseSlide(rawValue: key).map { ($0, phrase) }
        }))
    }
}

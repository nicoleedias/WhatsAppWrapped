//
//  SlidePhraseService.swift
//  WhatsAppWrapped
//
//  Pede as frases ao gerador (IA) e completa com as frases prontas o que faltar.
//  Sem a IA, a retrospectiva não é criada: a grátis não é gasta e a compra não é consumida.
//

import Foundation
import os

nonisolated enum SlidePhraseService {
    /// A IA não respondeu (sem internet, cota ou erro no modelo).
    struct Unavailable: Error {
        let underlying: any Error
    }

    private static let logger = Logger(subsystem: "WhatsAppWrapped", category: "Phrases")

    /// Frases da IA, completadas com as prontas nos slides que ela deixou de fora.
    /// Lança `Unavailable` quando a IA falha, para a pessoa não pagar por frases prontas.
    static func phrases(for stats: WrappedStats, using generator: any SlidePhraseGenerator) async throws -> SlidePhrases {
        let slides = PhraseSlide.applicable(to: stats)
        do {
            return try await generator.phrases(for: stats, slides: slides)
                .filled(with: FallbackPhrases.phrases(for: stats, slides: slides))
        } catch is CancellationError {
            throw CancellationError()
        } catch {
            logger.error("Frases da IA indisponíveis: \(error)")
            throw Unavailable(underlying: error)
        }
    }
}

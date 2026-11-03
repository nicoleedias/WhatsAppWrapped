//
//  SavedRetrospective.swift
//  WhatsAppWrapped
//
//  Retrospectiva guardada no aparelho para a lista "Minhas retrospectivas". Só números e frases:
//  nenhum texto de mensagem é salvo (o começo do maior textão é apagado antes de guardar).
//

import Foundation

nonisolated struct SavedRetrospective: Codable, Identifiable, Sendable {
    let id: UUID
    let createdAt: Date
    let stats: WrappedStats
    let phrases: SlidePhrases

    init(result: WrappedResult, id: UUID = UUID(), createdAt: Date = .now) {
        self.id = id
        self.createdAt = createdAt
        stats = result.stats.removingMessageText()
        phrases = result.phrases
    }

    var result: WrappedResult {
        WrappedResult(stats: stats, phrases: phrases)
    }
}

private extension WrappedStats {
    /// Tira o trecho do maior textão, o único texto de mensagem que as estatísticas guardam.
    nonisolated func removingMessageText() -> WrappedStats {
        WrappedStats(
            isGroup: isGroup,
            period: period,
            participants: participants,
            exporter: exporter,
            title: title,
            messages: messages,
            laughs: laughs,
            emojis: emojis,
            words: words,
            responseTimes: responseTimes,
            streak: streak,
            hours: hours,
            media: media,
            longMessages: LongMessageStats(
                averageLengthByPerson: longMessages.averageLengthByPerson,
                longest: longMessages.longest.map { .init(name: $0.name, length: $0.length, date: $0.date, text: "") }
            ),
            calls: calls
        )
    }
}

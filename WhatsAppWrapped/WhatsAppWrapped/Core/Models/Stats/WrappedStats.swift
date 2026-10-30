//
//  WrappedStats.swift
//  WhatsAppWrapped
//
//  Todos os números da retrospectiva, um campo por slide. É o que a análise devolve
//  e o que as telas e a IA recebem. Os tipos de cada slide estão na pasta Stats.
//

import Foundation

/// Tudo que os slides do Wrapped mostram, calculado no aparelho.
/// Rankings estão sempre em ordem decrescente.
nonisolated struct WrappedStats: Codable, Sendable {
    let isGroup: Bool
    let period: Period
    let participants: [String]
    /// Quem exportou a conversa, para os slides dizerem "Você". nil quando não dá para saber.
    let exporter: String?
    /// Nome da conversa ou do grupo. nil quando não dá para saber.
    let title: String?
    let messages: MessageStats        // 08, 19, 20
    let laughs: LaughStats            // 09
    let emojis: EmojiStats            // 10–11
    let words: WordStats              // 12–13
    let responseTimes: [ResponseTime] // 14
    let streak: StreakStats           // 15
    let hours: HourStats              // 16
    let media: MediaStats             // 17, 17d, 17e
    let longMessages: LongMessageStats // 18
    let calls: CallStats              // ligações

    struct Period: Codable, Sendable {
        let start: Date
        let end: Date
    }
}

nonisolated struct PersonCount: Codable, Sendable, Hashable {
    let name: String
    let count: Int
}

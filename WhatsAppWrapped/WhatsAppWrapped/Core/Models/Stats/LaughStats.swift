//
//  LaughStats.swift
//  WhatsAppWrapped
//
//  Slide 09: quantas mensagens tiveram risada, quem ri mais e os tipos de risada.
//

import Foundation

nonisolated struct LaughStats: Codable, Sendable {
    /// Mensagens com pelo menos uma risada.
    let total: Int
    let byPerson: [PersonCount]
    /// Ocorrências por tipo normalizado ("kkk", "haha", "😂"…). Top 10.
    let byType: [TypeCount]

    struct TypeCount: Codable, Sendable, Hashable {
        let laugh: String
        let count: Int
    }
}

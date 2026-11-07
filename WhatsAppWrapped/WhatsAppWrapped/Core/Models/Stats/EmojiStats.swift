//
//  EmojiStats.swift
//  WhatsAppWrapped
//
//  Slides 10–11: emojis mais usados e o favorito de cada pessoa.
//

import Foundation

nonisolated struct EmojiStats: Codable, Sendable {
    let total: Int
    /// Top 10.
    let top: [EmojiCount]
    let favoriteByPerson: [PersonEmoji]

    struct EmojiCount: Codable, Sendable, Hashable {
        let emoji: String
        let count: Int
    }

    struct PersonEmoji: Codable, Sendable, Hashable {
        let name: String
        let emoji: String
        let count: Int
    }
}

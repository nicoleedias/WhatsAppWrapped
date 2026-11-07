//
//  EmojiAnalyzer.swift
//  WhatsAppWrapped
//
//  Slides 10–11: conta emojis no geral e o favorito de cada pessoa.
//

import Foundation

/// Slides 10 e 11: emojis mais usados no geral e por pessoa.
nonisolated enum EmojiAnalyzer {
    static func analyze(_ messages: [Message]) -> EmojiStats {
        var overall: [String: Int] = [:]
        var byPerson: [String: [String: Int]] = [:]

        for message in messages where message.isText {
            for emoji in emojis(in: message.text) {
                overall[emoji, default: 0] += 1
                byPerson[message.author, default: [:]][emoji, default: 0] += 1
            }
        }

        let top = sorted(overall).prefix(10).map { EmojiStats.EmojiCount(emoji: $0.key, count: $0.value) }
        let favorites = byPerson
            .compactMap { name, counts in
                sorted(counts).first.map { EmojiStats.PersonEmoji(name: name, emoji: $0.key, count: $0.value) }
            }
            .sorted { ($0.count, $1.name) > ($1.count, $0.name) }

        return EmojiStats(total: overall.values.reduce(0, +), top: top, favoriteByPerson: favorites)
    }

    /// Emojis do texto, com tom de pele removido (👍🏽 conta como 👍).
    static func emojis(in text: String) -> [String] {
        text.compactMap { character in
            let scalars = character.unicodeScalars
            guard let first = scalars.first else { return nil }
            // Dígitos e "#" também são emoji para o Unicode; só contam com o sufixo de emoji (1️⃣).
            let isEmoji = first.properties.isEmojiPresentation
                || (first.properties.isEmoji && scalars.count > 1)
            guard isEmoji else { return nil }

            var normalized = String.UnicodeScalarView()
            normalized.append(contentsOf: scalars.filter { !(0x1F3FB...0x1F3FF).contains($0.value) })
            return String(normalized)
        }
    }

    private static func sorted(_ counts: [String: Int]) -> [(key: String, value: Int)] {
        counts.sorted { ($0.value, $1.key) > ($1.value, $0.key) }
    }
}

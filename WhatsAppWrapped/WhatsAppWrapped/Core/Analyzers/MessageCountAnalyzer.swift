//
//  MessageCountAnalyzer.swift
//  WhatsAppWrapped
//
//  Slides 08, 19 e 20: conta mensagens por pessoa, pódio e fantasmas do grupo.
//

import Foundation

/// Slides 08 (total), 19 (pódio) e 20 (quem nunca aparece).
nonisolated enum MessageCountAnalyzer {
    /// `participants` inclui quem não escreveu no período, para aparecer com 0.
    static func analyze(_ messages: [Message], participants: [String], isGroup: Bool) -> MessageStats {
        var counts = Dictionary(uniqueKeysWithValues: participants.map { ($0, 0) })
        for message in messages {
            counts[message.author, default: 0] += 1
        }
        let ranking = PersonCount.ranking(counts)

        guard isGroup, let fewest = ranking.last?.count else {
            return MessageStats(total: messages.count, byPerson: ranking, podium: nil, ghosts: nil)
        }
        return MessageStats(
            total: messages.count,
            byPerson: ranking,
            podium: Array(ranking.prefix(3)),
            ghosts: ranking.filter { $0.count == fewest }
        )
    }
}

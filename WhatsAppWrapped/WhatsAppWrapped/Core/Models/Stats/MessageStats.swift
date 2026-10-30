//
//  MessageStats.swift
//  WhatsAppWrapped
//
//  Slides 08, 19 e 20: total de mensagens, quem mais fala, pódio e fantasmas do grupo.
//

import Foundation

nonisolated struct MessageStats: Codable, Sendable {
    let total: Int
    let byPerson: [PersonCount]
    /// Top 3. Só em grupo.
    let podium: [PersonCount]?
    /// Quem tem menos mensagens, incluindo quem nunca escreveu. Só em grupo.
    let ghosts: [PersonCount]?
}

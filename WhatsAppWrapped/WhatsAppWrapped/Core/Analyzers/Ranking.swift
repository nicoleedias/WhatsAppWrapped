//
//  Ranking.swift
//  WhatsAppWrapped
//
//  Ordena contagens por pessoa (maior primeiro, empate em ordem alfabética). Usado por todos os analyzers.
//

import Foundation

nonisolated extension PersonCount {
    /// Ordem decrescente de contagem; empates em ordem alfabética, para o resultado ser sempre o mesmo.
    static func ranking(_ counts: [String: Int]) -> [PersonCount] {
        counts
            .map { PersonCount(name: $0.key, count: $0.value) }
            .sorted { ($0.count, $1.name) > ($1.count, $0.name) }
    }
}

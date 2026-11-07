//
//  CallStats.swift
//  WhatsAppWrapped
//
//  Slides 17b–17c: ligações de voz e vídeo, atendidas e perdidas, duração.
//

import Foundation

nonisolated struct CallStats: Codable, Sendable {
    /// Todas as chamadas, atendidas ou não.
    let total: Int
    let voice: Int
    let video: Int
    let answered: Int
    let missed: Int
    /// Média das chamadas atendidas. nil se nenhuma tiver duração.
    let averageDuration: TimeInterval?
    let longestDuration: TimeInterval?
    /// Quem mais liga.
    let byCaller: [PersonCount]

    /// Arredondado; somado com `videoPercentage` dá sempre 100.
    var voicePercentage: Int {
        total == 0 ? 0 : Int((Double(voice) / Double(total) * 100).rounded())
    }

    var videoPercentage: Int {
        total == 0 ? 0 : 100 - voicePercentage
    }
}

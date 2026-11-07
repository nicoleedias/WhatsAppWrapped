//
//  ResponseTime.swift
//  WhatsAppWrapped
//
//  Slide 14: tempo médio de resposta de cada pessoa.
//

import Foundation

nonisolated struct ResponseTime: Codable, Sendable {
    let name: String
    let averageMinutes: Double
    let medianMinutes: Double
    /// Quantas respostas entraram na conta.
    let responses: Int
}

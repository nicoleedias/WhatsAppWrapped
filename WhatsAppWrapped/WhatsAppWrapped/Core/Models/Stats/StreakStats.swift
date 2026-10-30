//
//  StreakStats.swift
//  WhatsAppWrapped
//
//  Slide 15: maior sequência de dias seguidos conversando.
//

import Foundation

nonisolated struct StreakStats: Codable, Sendable {
    let longest: Int
    let start: Date?
    let end: Date?
    let daysWithMessages: Int
}

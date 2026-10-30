//
//  StreakAnalyzer.swift
//  WhatsAppWrapped
//
//  Slide 15: maior sequência de dias seguidos com mensagem.
//

import Foundation

/// Slide 15: maior sequência de dias seguidos com pelo menos uma mensagem.
nonisolated enum StreakAnalyzer {
    static func analyze(_ messages: [Message]) -> StreakStats {
        let days = Set(messages.map { ChatCalendar.startOfDay($0.date) }).sorted()
        guard let firstDay = days.first else {
            return StreakStats(longest: 0, start: nil, end: nil, daysWithMessages: 0)
        }

        var best = (length: 1, start: firstDay, end: firstDay)
        var current = best
        for day in days.dropFirst() {
            if day == ChatCalendar.adding(days: 1, to: current.end) {
                current.length += 1
                current.end = day
            } else {
                current = (1, day, day)
            }
            if current.length > best.length { best = current }
        }
        return StreakStats(longest: best.length, start: best.start, end: best.end, daysWithMessages: days.count)
    }
}

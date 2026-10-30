//
//  HourAnalyzer.swift
//  WhatsAppWrapped
//
//  Slide 16: mensagens por hora e período do dia favorito.
//

import Foundation

/// Slide 16: horário em que mais conversam.
nonisolated enum HourAnalyzer {
    static func analyze(_ messages: [Message]) -> HourStats {
        var byHour = Array(repeating: 0, count: 24)
        for message in messages {
            byHour[ChatCalendar.hour(message.date)] += 1
        }

        var byPart: [HourStats.PartOfDay: Int] = [:]
        for (hour, count) in byHour.enumerated() {
            byPart[HourStats.PartOfDay(hour: hour), default: 0] += count
        }
        let peakHour = byHour.indices.max { byHour[$0] < byHour[$1] || (byHour[$0] == byHour[$1] && $0 > $1) } ?? 0
        let favorite = HourStats.PartOfDay.allCases.max { byPart[$0, default: 0] < byPart[$1, default: 0] } ?? .night

        return HourStats(byHour: byHour, peakHour: peakHour, favoritePartOfDay: favorite)
    }
}

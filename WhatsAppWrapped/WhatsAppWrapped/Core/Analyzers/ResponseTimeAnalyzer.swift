//
//  ResponseTimeAnalyzer.swift
//  WhatsAppWrapped
//
//  Slide 14: tempo que cada pessoa leva para responder.
//

import Foundation

/// Slide 14: quem demora mais para responder.
nonisolated enum ResponseTimeAnalyzer {
    /// Intervalos maiores que isso são conversa nova, não demora para responder.
    private static let maximumGap: TimeInterval = 12 * 60 * 60

    /// Ordem decrescente de média: quem mais demora vem primeiro.
    static func analyze(_ messages: [Message]) -> [ResponseTime] {
        var minutesByPerson: [String: [Double]] = [:]
        for (previous, message) in zip(messages, messages.dropFirst()) where message.author != previous.author {
            let gap = message.date.timeIntervalSince(previous.date)
            guard gap >= 0, gap <= maximumGap else { continue }
            minutesByPerson[message.author, default: []].append(gap / 60)
        }

        return minutesByPerson
            .map { name, minutes in
                ResponseTime(
                    name: name,
                    averageMinutes: roundedToTenth(minutes.reduce(0, +) / Double(minutes.count)),
                    medianMinutes: roundedToTenth(median(minutes)),
                    responses: minutes.count
                )
            }
            .sorted { ($0.averageMinutes, $1.name) > ($1.averageMinutes, $0.name) }
    }

    private static func median(_ values: [Double]) -> Double {
        let sorted = values.sorted()
        let middle = sorted.count / 2
        return sorted.count.isMultiple(of: 2) ? (sorted[middle - 1] + sorted[middle]) / 2 : sorted[middle]
    }

    private static func roundedToTenth(_ value: Double) -> Double {
        (value * 10).rounded() / 10
    }
}

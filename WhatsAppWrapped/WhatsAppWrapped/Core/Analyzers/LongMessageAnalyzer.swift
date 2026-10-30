//
//  LongMessageAnalyzer.swift
//  WhatsAppWrapped
//
//  Slide 18: tamanho médio das mensagens de cada pessoa e o maior textão.
//

import Foundation

/// Slide 18: quem manda mais textão.
nonisolated enum LongMessageAnalyzer {
    static func analyze(_ messages: [Message]) -> LongMessageStats {
        var totals: [String: (characters: Int, messages: Int)] = [:]
        var longest: Message?

        for message in messages where message.isText {
            let length = message.text.count
            totals[message.author, default: (0, 0)].characters += length
            totals[message.author, default: (0, 0)].messages += 1
            if length > longest?.text.count ?? 0 { longest = message }
        }

        let averages = totals.mapValues { Int((Double($0.characters) / Double($0.messages)).rounded()) }
        return LongMessageStats(
            averageLengthByPerson: PersonCount.ranking(averages),
            longest: longest.map { .init(name: $0.author, length: $0.text.count, date: $0.date, text: $0.text) }
        )
    }
}

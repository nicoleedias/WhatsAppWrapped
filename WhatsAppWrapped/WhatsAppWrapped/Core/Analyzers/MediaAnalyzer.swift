//
//  MediaAnalyzer.swift
//  WhatsAppWrapped
//
//  Slides 17, 17d e 17e: áudios, fotos e figurinhas (total, por pessoa, dia recorde e por mês).
//

import Foundation

/// Slides 17 (áudios), 17d (fotos), 17e (figurinhas) e campeão de mídias.
nonisolated enum MediaAnalyzer {
    static func analyze(_ messages: [Message], period: ClosedRange<Date>) -> MediaStats {
        var byPerson: [String: Int] = [:]
        var byType: [MediaType: [Message]] = [:]
        var total = 0

        for message in messages {
            guard case .media(let type) = message.kind else { continue }
            total += 1
            byPerson[message.author, default: 0] += 1
            byType[type, default: []].append(message)
        }

        // Exportação do Android só diz "<Mídia oculta>": não dá para saber o que é foto, áudio ou figurinha.
        let knowsMediaType = total == 0 || byType.keys.contains { $0 != .unknown }
        func stats(for type: MediaType) -> MediaTypeStats? {
            knowsMediaType ? typeStats(byType[type] ?? [], allMessages: messages.count, period: period) : nil
        }

        return MediaStats(
            total: total,
            byPerson: PersonCount.ranking(byPerson),
            audios: stats(for: .audio),
            photos: stats(for: .image),
            stickers: stats(for: .sticker)
        )
    }

    private static func typeStats(_ items: [Message], allMessages: Int, period: ClosedRange<Date>) -> MediaTypeStats {
        var byPerson: [String: Int] = [:]
        var byDay: [Date: Int] = [:]
        var byMonth: [Date: Int] = [:]
        for item in items {
            byPerson[item.author, default: 0] += 1
            byDay[ChatCalendar.startOfDay(item.date), default: 0] += 1
            byMonth[ChatCalendar.startOfMonth(item.date), default: 0] += 1
        }

        // Empate: o dia mais antigo.
        let busiestDay = byDay.max { ($0.value, $1.key) < ($1.value, $0.key) }
        let months = sequence(first: ChatCalendar.startOfMonth(period.lowerBound)) {
            ChatCalendar.calendar.date(byAdding: .month, value: 1, to: $0)!
        }
        .prefix { $0 <= period.upperBound }

        return MediaTypeStats(
            total: items.count,
            byPerson: PersonCount.ranking(byPerson),
            busiestDay: busiestDay.map { .init(date: $0.key, count: $0.value) },
            byMonth: months.map { .init(month: $0, count: byMonth[$0, default: 0]) },
            messagesPerItem: items.isEmpty ? nil : Int((Double(allMessages) / Double(items.count)).rounded())
        )
    }
}

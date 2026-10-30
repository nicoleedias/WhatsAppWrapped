//
//  WrappedResult+Preview.swift
//  WhatsAppWrapped
//
//  Retrospectivas de exemplo para os previews dos slides: uma conversa a dois e um grupo.
//

import Foundation

extension WrappedResult {
    static let preview = WrappedResult(
        stats: .preview(
            isGroup: false,
            title: "Bia",
            participants: ["Nicole", "Bia"],
            messages: 30_597,
            topEmoji: .init(emoji: "😭", count: 1_365),
            laughs: 2_847,
            streak: 95,
            peakHour: 23,
            responseTimes: [("Nicole", 32), ("Bia", 222)]
        ),
        phrases: SlidePhrases()
    )

    static let previewGroup = WrappedResult(
        stats: .preview(
            isGroup: true,
            title: "Rolê de sexta",
            participants: ["Nicole", "Bia", "Rafa", "Lu", "Caio", "Tânia"],
            messages: 84_210,
            topEmoji: .init(emoji: "😂", count: 3_902),
            laughs: 9_412,
            streak: 214,
            peakHour: 0,
            responseTimes: [("Nicole", 41), ("Caio", 552)]
        ),
        phrases: SlidePhrases()
    )
}

private extension WrappedStats {
    /// Só os campos que os slides usam têm valores de verdade; o resto fica vazio.
    static func preview(
        isGroup: Bool,
        title: String,
        participants: [String],
        messages: Int,
        topEmoji: EmojiStats.EmojiCount,
        laughs: Int,
        streak: Int,
        peakHour: Int,
        responseTimes: [(name: String, minutes: Double)]
    ) -> WrappedStats {
        let end = ChatCalendar.calendar.date(from: DateComponents(year: 2026, month: 10, day: 29))!
        let start = ChatCalendar.adding(days: -364, to: end)
        return WrappedStats(
            isGroup: isGroup,
            period: .init(start: start, end: end),
            participants: participants,
            exporter: participants.first,
            title: title,
            messages: MessageStats(total: messages, byPerson: [], podium: nil, ghosts: nil),
            laughs: LaughStats(total: laughs, byPerson: [], byType: []),
            emojis: EmojiStats(total: topEmoji.count, top: [topEmoji], favoriteByPerson: []),
            words: WordStats(top: [], byPerson: [], quiz: []),
            responseTimes: responseTimes.map {
                ResponseTime(name: $0.name, averageMinutes: $0.minutes, medianMinutes: $0.minutes, responses: 100)
            },
            streak: StreakStats(longest: streak, start: nil, end: nil, daysWithMessages: streak),
            hours: HourStats(
                byHour: Array(repeating: 0, count: 24),
                peakHour: peakHour,
                favoritePartOfDay: HourStats.PartOfDay(hour: peakHour)
            ),
            media: MediaStats(total: 0, byPerson: [], audios: nil, photos: nil, stickers: nil),
            longMessages: LongMessageStats(averageLengthByPerson: [], longest: nil),
            calls: CallStats(
                total: 0, voice: 0, video: 0, answered: 0, missed: 0,
                averageDuration: nil, longestDuration: nil, byCaller: []
            )
        )
    }
}

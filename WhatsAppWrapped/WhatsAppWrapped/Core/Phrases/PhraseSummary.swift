//
//  PhraseSummary.swift
//  WhatsAppWrapped
//
//  Resumo das estatísticas em JSON que vai para a IA. A conversa em si nunca sai do aparelho.
//

import Foundation

nonisolated struct PhraseSummary: Encodable {
    /// Sem textos de mensagens: só contagens, nomes, emojis e palavras mais usadas.
    static func json(for stats: WrappedStats) throws -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys, .withoutEscapingSlashes]
        return String(decoding: try encoder.encode(PhraseSummary(stats)), as: UTF8.self)
    }

    let chatType: String
    let period: String
    let messages: MessageStats
    let laughs: LaughStats
    let topEmojis: [EmojiStats.EmojiCount]
    let favoriteEmojiByPerson: [EmojiStats.PersonEmoji]
    let topWords: [WordStats.WordCount]
    let responseTimes: [ResponseTime]
    let longestStreakDays: Int
    let daysWithMessages: Int
    let peakHour: Int
    let favoritePartOfDay: String
    let exporter: String?
    let audios: Media?
    let photos: Media?
    let stickers: Media?
    let averageMessageLengthByPerson: [PersonCount]
    let longestMessageCharacters: Int?
    let calls: Calls?
    let derived: Derived

    struct Media: Encodable {
        let total: Int
        let byPerson: [PersonCount]
        let busiestDay: String?
        let busiestDayCount: Int?
        let messagesPerItem: Int?
    }

    struct Calls: Encodable {
        let total, voice, video, answered, missed: Int
        let averageMinutes: Double?
        let longestMinutes: Int?
        let byCaller: [PersonCount]
    }

    struct Derived: Encodable {
        let periodDays: Int
        let messagesPerDay: Double
    }

    init(_ stats: WrappedStats) {
        let formatter = DateFormatter()
        formatter.calendar = ChatCalendar.calendar
        formatter.timeZone = ChatCalendar.timeZone
        formatter.dateFormat = "dd/MM/yyyy"
        let periodDays = (ChatCalendar.calendar.dateComponents([.day], from: stats.period.start, to: stats.period.end).day ?? 0) + 1

        chatType = stats.isGroup ? "grupo" : "conversa entre duas pessoas"
        period = "\(formatter.string(from: stats.period.start)) a \(formatter.string(from: stats.period.end))"
        messages = stats.messages
        laughs = stats.laughs
        topEmojis = Array(stats.emojis.top.prefix(5))
        favoriteEmojiByPerson = stats.emojis.favoriteByPerson
        topWords = Array(stats.words.top.prefix(10))
        responseTimes = stats.responseTimes
        longestStreakDays = stats.streak.longest
        daysWithMessages = stats.streak.daysWithMessages
        peakHour = stats.hours.peakHour
        favoritePartOfDay = switch stats.hours.favoritePartOfDay {
        case .lateNight: "madrugada"
        case .morning: "manhã"
        case .afternoon: "tarde"
        case .night: "noite"
        }
        exporter = stats.exporter
        func media(_ media: MediaTypeStats?) -> Media? {
            guard let media, media.total > 0 else { return nil }
            return Media(
                total: media.total,
                byPerson: media.byPerson,
                busiestDay: media.busiestDay.map { formatter.string(from: $0.date) },
                busiestDayCount: media.busiestDay?.count,
                messagesPerItem: media.messagesPerItem
            )
        }
        audios = media(stats.media.audios)
        photos = media(stats.media.photos)
        stickers = media(stats.media.stickers)
        averageMessageLengthByPerson = stats.longMessages.averageLengthByPerson
        longestMessageCharacters = stats.longMessages.longest?.length
        calls = stats.calls.total == 0 ? nil : Calls(
            total: stats.calls.total,
            voice: stats.calls.voice,
            video: stats.calls.video,
            answered: stats.calls.answered,
            missed: stats.calls.missed,
            averageMinutes: stats.calls.averageDuration.map { ($0 / 6).rounded() / 10 },
            longestMinutes: stats.calls.longestDuration.map { Int($0 / 60) },
            byCaller: stats.calls.byCaller
        )
        derived = Derived(
            periodDays: periodDays,
            messagesPerDay: (Double(stats.messages.total) / Double(max(periodDays, 1)) * 10).rounded() / 10
        )
    }
}

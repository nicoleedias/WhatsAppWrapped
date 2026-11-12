//
//  WrappedViewModel+Slides.swift
//  WhatsAppWrapped
//
//  Monta os slides na ordem e transforma as estatísticas nos textos de cada um. Os números em destaque
//  são da conversa toda ("Vocês trocaram…"); o que é de uma pessoa só aparece nas comparações, com quem
//  exportou como "Você". Slides sem dados ficam de fora.
//

import SwiftUI

extension WrappedViewModel {
    /// A ordem dos slides. Os que voltam nil (sem dados) ficam de fora.
    static func makeSlides(for stats: WrappedStats) -> [WrappedSlide] {
        let text = SlideText(stats: stats)
        let slides: [WrappedSlide?] = [
            WrappedSlide(MessagesSlide(headline: text.messages)),
            WrappedSlide(text.laughs.map(LaughsSlide.init)),
            WrappedSlide(text.emojiChampion.map { _ in EmojiMysterySlide(emojis: text.mysteryEmojis) }),
            WrappedSlide(text.emojiChampion.map(EmojiChampionSlide.init)),
            WrappedSlide(text.quiz.map(QuizSlide.init)),
            WrappedSlide(stats.words.top.isEmpty ? nil : WordsSlide(words: Array(stats.words.top.prefix(3)))),
            WrappedSlide(text.responseDuel.map(ResponseTimeSlide.init)),
            WrappedSlide(stats.streak.longest > 0 ? StreakSlide(headline: text.streak) : nil),
            WrappedSlide(HoursSlide(hours: text.hours)),
            WrappedSlide(text.audios.map(AudiosSlide.init)),
            WrappedSlide(text.incomingCall.map(IncomingCallSlide.init)),
            WrappedSlide(text.calls.map(CallsSlide.init)),
            WrappedSlide(text.photos.map(PhotosSlide.init)),
            WrappedSlide(text.stickers.map(StickersSlide.init)),
            WrappedSlide(text.longMessage.map(LongMessageSlide.init)),
            WrappedSlide(stats.isGroup ? text.podium.map { PodiumSlide(podium: $0, displayName: text.displayName) } : nil),
            WrappedSlide(stats.isGroup ? text.ghosts.map(GhostsSlide.init) : nil),
        ]
        return slides.compactMap { $0 }
    }
}

/// Os textos de um slide por propriedade. nil quando o slide não tem dados.
private struct SlideText {
    let stats: WrappedStats

    private static let locale = Locale(identifier: "pt_BR")

    func displayName(_ name: String) -> String {
        name == stats.exporter ? "Você" : name
    }

    /// A outra pessoa numa conversa a dois.
    private var otherPerson: String? {
        stats.participants.first { $0 != stats.exporter }
    }

    private var year: String {
        ChatCalendar.calendar.component(.year, from: stats.period.end).formatted(.number.grouping(.never))
    }

    private func count(_ value: Int, _ singular: String, _ plural: String) -> String {
        "\(value.formatted()) \(value == 1 ? singular : plural)"
    }

    // MARK: 08–09

    var messages: WrappedSlide.Headline {
        WrappedSlide.Headline(
            intro: stats.isGroup ? "O grupo trocou" : "Vocês trocaram",
            value: stats.messages.total.formatted(),
            caption: stats.messages.total == 1 ? "mensagem" : "mensagens"
        )
    }

    var laughs: WrappedSlide.Headline? {
        guard stats.laughs.total > 0 else { return nil }
        return WrappedSlide.Headline(
            intro: "Vocês riram",
            value: stats.laughs.total.formatted(),
            caption: stats.laughs.total == 1 ? "vez" : "vezes"
        )
    }

    // MARK: 10–11

    var emojiChampion: WrappedSlide.EmojiChampion? {
        stats.emojis.top.first.map {
            WrappedSlide.EmojiChampion(emoji: $0.emoji, count: $0.count, countText: count($0.count, "vez", "vezes"))
        }
    }

    /// Os emojis girando no suspense: os da conversa primeiro, completados com os de sempre.
    var mysteryEmojis: [String] {
        let own = stats.emojis.top.map(\.emoji)
        let filler = EmojiMysteryScene.defaultEmojis.filter { !own.contains($0) }
        return Array((own + filler).prefix(EmojiMysteryScene.defaultEmojis.count))
    }

    // MARK: 12–14

    /// As 4 palavras mais usadas na conversa; a resposta é a primeira.
    var quiz: WrappedSlide.Quiz? {
        let words = stats.words.top.prefix(4).map(\.word)
        guard words.count >= 2, let answer = words.first else { return nil }
        return WrappedSlide.Quiz(
            question: "Qual foi a palavra mais digitada na conversa?",
            options: words.sorted { $0.localizedStandardCompare($1) == .orderedAscending },
            answer: answer
        )
    }

    var responseDuel: WrappedSlide.ResponseDuel? {
        let sorted = stats.responseTimes.sorted { $0.averageMinutes < $1.averageMinutes }
        guard sorted.count > 1, let fastest = sorted.first, let slowest = sorted.last else { return nil }
        let slowestName = displayName(slowest.name)
        return WrappedSlide.ResponseDuel(
            title: "Quem demora mais pra responder?",
            fastest: .init(label: displayName(fastest.name), time: SummaryViewModel.duration(minutes: fastest.averageMinutes)),
            slowest: .init(label: slowestName, time: SummaryViewModel.duration(minutes: slowest.averageMinutes)),
            typingCaption: slowestName == "Você" ? "Você está digitando…" : "\(slowestName) está digitando…"
        )
    }

    // MARK: 15–16

    var streak: WrappedSlide.Headline {
        WrappedSlide.Headline(
            value: stats.streak.longest.formatted(),
            caption: stats.streak.longest == 1 ? "dia trocando mensagem" : "dias seguidos trocando mensagem"
        )
    }

    var hours: WrappedSlide.Hours {
        let style = HourStyle(stats.hours.favoritePartOfDay)
        return WrappedSlide.Hours(
            partOfDay: stats.hours.favoritePartOfDay,
            headline: WrappedSlide.Headline(
                intro: "Vocês são do time da \(style.teamName)",
                value: "\(stats.hours.peakHour)h",
                caption: "é quando a conversa mais ferve"
            )
        )
    }

    // MARK: 17

    var audios: WrappedSlide.Audios? {
        guard let audios = stats.media.audios, audios.total > 0 else { return nil }
        let ranked = audios.byPerson.sorted { $0.count > $1.count }
        let headline = WrappedSlide.Headline(
            intro: "Vocês trocaram",
            value: audios.total.formatted(),
            caption: audios.total == 1 ? "áudio" : "áudios"
        )
        guard ranked.count > 1 else { return WrappedSlide.Audios(headline: headline, comparison: nil) }
        let entry = { (person: PersonCount) in
            AudioComparison.Entry(name: displayName(person.name), duration: count(person.count, "áudio", "áudios"))
        }
        return WrappedSlide.Audios(headline: headline, comparison: (entry(ranked[0]), entry(ranked[1])))
    }

    /// Quem aparece "chamando": nunca quem exportou. A dois, a outra pessoa; no grupo, o nome do grupo
    /// (ou, sem ele, quem mais ligou).
    var incomingCall: WrappedSlide.IncomingCall? {
        guard stats.calls.total > 0 else { return nil }
        let topOtherCaller = stats.calls.byCaller
            .filter { $0.name != stats.exporter }
            .max { $0.count < $1.count }?.name
        let caller = stats.isGroup ? stats.title ?? topOtherCaller : otherPerson ?? topOtherCaller
        return WrappedSlide.IncomingCall(name: caller ?? "Alguém", isGroup: stats.isGroup)
    }

    var calls: WrappedSlide.Calls? {
        let calls = stats.calls
        guard calls.total > 0 else { return nil }
        let longest = calls.longestDuration.map { " · a maior durou \(Self.hoursAndMinutes($0))" } ?? ""
        return WrappedSlide.Calls(
            title: "Vocês se ligaram \(count(calls.total, "vez", "vezes"))",
            voice: calls.voice,
            video: calls.video,
            voicePercentage: calls.voicePercentage,
            videoPercentage: calls.videoPercentage,
            average: calls.averageDuration.map { Self.minutesAndSeconds($0) },
            averageDetail: "minutos por chamada\(longest)"
        )
    }

    var photos: WrappedSlide.Photos? {
        guard let photos = stats.media.photos, photos.total > 0 else { return nil }
        let emojis = ["🌅", "🎉", "📸"]
        let busiestMonths = photos.byMonth
            .filter { $0.count > 0 }
            .sorted { $0.count > $1.count }
            .prefix(3)
            .sorted { $0.month < $1.month }
        let monthStyle = Date.FormatStyle(locale: Self.locale, calendar: ChatCalendar.calendar, timeZone: ChatCalendar.timeZone)
            .month(.abbreviated)
        return WrappedSlide.Photos(
            headline: WrappedSlide.Headline(
                intro: "Vocês trocaram",
                value: photos.total.formatted(),
                caption: "\(photos.total == 1 ? "foto" : "fotos") em \(year)"
            ),
            polaroids: busiestMonths.enumerated().map { index, month in
                PolaroidStack.Item(
                    emoji: emojis[index % emojis.count],
                    label: month.month.formatted(monthStyle).replacing(".", with: "")
                )
            },
            busiestDay: photos.busiestDay.map { day in
                let date = day.date.formatted(
                    Date.FormatStyle(locale: Self.locale, calendar: ChatCalendar.calendar, timeZone: ChatCalendar.timeZone)
                        .day().month(.wide)
                )
                return "\(date): \(count(day.count, "foto", "fotos")) num dia só"
            }
        )
    }

    var stickers: WrappedSlide.Stickers? {
        guard let stickers = stats.media.stickers, stickers.total > 0 else { return nil }
        let ranked = stickers.byPerson.sorted { $0.count > $1.count }
        var split: (SplitBar.Side, SplitBar.Side)?
        if !stats.isGroup, ranked.count == 2 {
            split = (
                SplitBar.Side(name: displayName(ranked[0].name), count: ranked[0].count),
                SplitBar.Side(name: displayName(ranked[1].name), count: ranked[1].count)
            )
        }
        return WrappedSlide.Stickers(
            count: stickers.total,
            frequency: stickers.messagesPerItem.map { "1 figurinha a cada \(count($0, "mensagem", "mensagens"))" },
            split: split.map { (leading: $0.0, trailing: $0.1) }
        )
    }

    // MARK: 18–20

    var longMessage: WrappedSlide.LongMessage? {
        guard let longest = stats.longMessages.longest else { return nil }
        let detail = LongMessageQuote.detail(length: longest.length, date: longest.date)
        return WrappedSlide.LongMessage(
            title: "O maior textão do \(stats.periodNoun) foi...",
            text: longest.text.isEmpty ? nil : longest.text,
            detail: "\(displayName(longest.name)) · \(detail)"
        )
    }

    var podium: [PersonCount]? {
        guard let podium = stats.messages.podium, !podium.isEmpty else { return nil }
        return podium
    }

    var ghosts: [GhostList.Ghost]? {
        guard let ghosts = stats.messages.ghosts, !ghosts.isEmpty else { return nil }
        return ghosts.prefix(3).map { ghost in
            GhostList.Ghost(
                name: displayName(ghost.name),
                detail: ghost.count == 0 ? "só lê" : "quase não fala",
                value: count(ghost.count, "mensagem", "mensagens")
            )
        }
    }

    // MARK: Durações

    /// 847 s → "14:07".
    private static func minutesAndSeconds(_ seconds: TimeInterval) -> String {
        let total = Int(seconds.rounded())
        return "\(total / 60):\(String(format: "%02d", total % 60))"
    }

    /// 11.520 s → "3h12"; menos de uma hora → "48min".
    private static func hoursAndMinutes(_ seconds: TimeInterval) -> String {
        let minutes = Int((seconds / 60).rounded())
        guard minutes >= 60 else { return "\(minutes)min" }
        return "\(minutes / 60)h\(String(format: "%02d", minutes % 60))"
    }
}

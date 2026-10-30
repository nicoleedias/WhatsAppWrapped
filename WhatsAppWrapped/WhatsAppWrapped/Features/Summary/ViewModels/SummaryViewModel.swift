//
//  SummaryViewModel.swift
//  WhatsAppWrapped
//
//  Slide 21 (resumo final): transforma as estatísticas nos textos do card — título, total, os quatro
//  destaques e quem demora mais para responder. Quem exportou a conversa aparece como "Você".
//

import Foundation
import Observation

@Observable
final class SummaryViewModel {
    /// Um destaque da grade 2×2. A view escolhe a cor pelo `kind`.
    struct Highlight: Hashable {
        enum Kind { case emoji, laughs, streak, peakHour }

        let kind: Kind
        let emoji: String
        let value: String
        let caption: String
    }

    private let stats: WrappedStats

    init(result: WrappedResult) {
        stats = result.stats
    }

    var isGroup: Bool { stats.isGroup }

    /// Quem exportou vem primeiro, como "Você".
    var participants: [String] {
        let others = stats.participants.filter { $0 != stats.exporter }
        return (stats.exporter == nil ? [] : ["Você"]) + others
    }

    /// "Você & Nicole" ou o nome do grupo. A dois, o nome da conversa é só o contato, então não entra.
    var title: String {
        guard isGroup else { return participants.prefix(2).joined(separator: " & ") }
        return stats.title ?? "Seu grupo"
    }

    /// "💬 sua conversa em 2026" ou "💬 6 pessoas · 2026".
    var subtitle: String {
        isGroup ? "💬 \(stats.participants.count) pessoas · \(year)" : "💬 sua conversa em \(year)"
    }

    var messageCount: Int { stats.messages.total }

    var highlights: [Highlight] {
        let topEmoji = stats.emojis.top.first
        return [
            Highlight(
                kind: .emoji,
                emoji: topEmoji?.emoji ?? "😶",
                value: topEmoji.map { "\($0.count.formatted())×" } ?? "nenhum",
                caption: "emoji #1"
            ),
            Highlight(kind: .laughs, emoji: "😂", value: stats.laughs.total.formatted(), caption: "risadas"),
            Highlight(
                kind: .streak,
                emoji: "🔥",
                value: stats.streak.longest == 1 ? "1 dia" : "\(stats.streak.longest) dias",
                caption: "de sequência"
            ),
            Highlight(
                kind: .peakHour,
                emoji: HourStyle(stats.hours.favoritePartOfDay).emoji,
                value: "\(stats.hours.peakHour)h",
                caption: "horário de pico"
            ),
        ]
    }

    /// "Nicole · 3h42min". nil sem respostas suficientes para comparar.
    var slowestResponder: String? {
        guard stats.responseTimes.count > 1,
              let slowest = stats.responseTimes.max(by: { $0.averageMinutes < $1.averageMinutes })
        else { return nil }
        return "\(displayName(slowest.name)) · \(Self.duration(minutes: slowest.averageMinutes))"
    }

    /// Ano do fim do período, sem separador de milhar.
    private var year: String {
        ChatCalendar.calendar.component(.year, from: stats.period.end).formatted(.number.grouping(.never))
    }

    private func displayName(_ name: String) -> String {
        name == stats.exporter ? "Você" : name
    }

    /// "32min", "3h42min", "2h".
    static func duration(minutes: Double) -> String {
        let total = max(1, Int(minutes.rounded()))
        let hours = total / 60
        let rest = total % 60
        guard hours > 0 else { return "\(rest)min" }
        return rest == 0 ? "\(hours)h" : "\(hours)h\(String(format: "%02d", rest))min"
    }
}

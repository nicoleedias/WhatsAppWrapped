//
//  WrappedService.swift
//  WhatsAppWrapped
//
//  Caminho completo do arquivo até as estatísticas: importa, faz o parsing, filtra o período e roda os analyzers.
//  O período é de 12 meses na retrospectiva paga e de 30 dias na grátis.
//

import Foundation

/// Junta parsing e análises: do arquivo exportado até as estatísticas de todos os slides.
nonisolated enum WrappedService {
    /// Lê e analisa o .zip ou .txt fora da main thread. Conversas longas têm dezenas de milhares de mensagens.
    /// Erros são sempre `ChatImporter.ImportError`, com mensagem pronta para mostrar.
    @concurrent
    static func loadChat(fileURL: URL) async throws -> Chat {
        let text = try ChatImporter.chatText(from: fileURL)
        guard var chat = try? ChatParser.parse(text) else { throw ChatImporter.ImportError.notAWhatsAppChat }
        // O nome do arquivo é o nome atual da conversa; as mensagens de sistema podem ser antigas.
        if let title = ChatTitle.fromFileName(fileURL.lastPathComponent) { chat.title = title }
        return chat
    }

    /// Estatísticas fora da main thread. `isTrial`: só os últimos 30 dias (a retrospectiva grátis);
    /// senão, os últimos 12 meses.
    @concurrent
    static func makeStats(for chat: Chat, isTrial: Bool) async -> WrappedStats {
        makeStats(from: chat, period: isTrial ? trialPeriod(for: chat) : nil)
    }

    /// `period`: dias inclusivos, criados com `ChatCalendar.calendar`. Sem período, usa `defaultPeriod(for:)`.
    static func makeStats(from chat: Chat, period: ClosedRange<Date>? = nil) -> WrappedStats {
        let period = period.map { ChatCalendar.startOfDay($0.lowerBound)...ChatCalendar.startOfDay($0.upperBound) }
            ?? defaultPeriod(for: chat)
        let endOfPeriod = ChatCalendar.adding(days: 1, to: period.upperBound)
        // Segunda proteção contra o nome do grupo virar participante (ver `ChatParser.parse`).
        let groupName = chat.isGroup ? chat.title : nil
        let messages = chat.messages.filter {
            $0.date >= period.lowerBound && $0.date < endOfPeriod && $0.author != groupName
        }
        let calls = chat.calls.filter { $0.date >= period.lowerBound && $0.date < endOfPeriod }

        let messageStats = MessageCountAnalyzer.analyze(
            messages,
            participants: participants(of: chat, writing: messages, period: period),
            isGroup: chat.isGroup
        )
        let participants = messageStats.byPerson.map(\.name)

        return WrappedStats(
            isGroup: chat.isGroup,
            period: .init(start: period.lowerBound, end: period.upperBound),
            participants: participants,
            exporter: chat.exporter,
            title: chat.title,
            messages: messageStats,
            laughs: LaughAnalyzer.analyze(messages),
            emojis: EmojiAnalyzer.analyze(messages),
            words: WordAnalyzer.analyze(messages, participants: participants),
            responseTimes: ResponseTimeAnalyzer.analyze(messages),
            streak: StreakAnalyzer.analyze(messages),
            hours: HourAnalyzer.analyze(messages),
            media: MediaAnalyzer.analyze(messages, period: period),
            longMessages: LongMessageAnalyzer.analyze(messages),
            calls: CallAnalyzer.analyze(calls)
        )
    }

    /// Os 12 meses que terminam no dia da última mensagem (ou desde a primeira, se a conversa for mais curta).
    static func defaultPeriod(for chat: Chat) -> ClosedRange<Date> {
        let firstDay = ChatCalendar.startOfDay(chat.messages.first?.date ?? .now)
        let lastDay = ChatCalendar.startOfDay(chat.messages.last?.date ?? .now)
        let oneYearBefore = ChatCalendar.calendar.date(byAdding: .year, value: -1, to: lastDay)!
        return max(firstDay, ChatCalendar.adding(days: 1, to: oneYearBefore))...lastDay
    }

    /// Dias da retrospectiva grátis.
    static let trialDays = 30

    /// Os 30 dias que terminam no dia da última mensagem (ou desde a primeira, se a conversa for mais curta).
    static func trialPeriod(for chat: Chat) -> ClosedRange<Date> {
        let firstDay = ChatCalendar.startOfDay(chat.messages.first?.date ?? .now)
        let lastDay = ChatCalendar.startOfDay(chat.messages.last?.date ?? .now)
        return max(firstDay, ChatCalendar.adding(days: 1 - trialDays, to: lastDay))...lastDay
    }

    /// Quem escreveu no período e, em grupo, também quem estava no grupo e não escreveu nada.
    private static func participants(of chat: Chat, writing messages: [Message], period: ClosedRange<Date>) -> [String] {
        var result = Set(messages.map(\.author))
        guard chat.isGroup else { return Array(result) }

        let changesByName = Dictionary(grouping: chat.membershipChanges, by: \.name)
        for name in Set(chat.authors).union(changesByName.keys) where !result.contains(name) && name != chat.title {
            let changes = changesByName[name] ?? []
            let leftBefore = changes.last { $0.date < period.lowerBound }?.joined == false
            let joinedAfter = changes.first.map { $0.joined && $0.date > period.upperBound } ?? false
            if !leftBefore && !joinedAfter { result.insert(name) }
        }
        return Array(result)
    }
}

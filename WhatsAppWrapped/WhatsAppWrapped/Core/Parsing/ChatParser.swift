//
//  ChatParser.swift
//  WhatsAppWrapped
//
//  Transforma o texto do _chat.txt em `Chat`: separa mensagens, ligações e avisos e lê datas e autores.
//

import Foundation

/// Lê o `_chat.txt` exportado do WhatsApp (iPhone ou Android, português ou inglês).
nonisolated enum ChatParser {
    enum ParseError: Error, Equatable {
        /// Nenhuma linha no formato de mensagem do WhatsApp.
        case noMessages
    }

    static func parse(_ fileContents: String) throws -> Chat {
        let lines = fileContents
            .replacingOccurrences(of: "\r\n", with: "\n")
            .split(separator: "\n", omittingEmptySubsequences: false)

        var entries: [RawEntry] = []
        for line in lines {
            if let header = Header(line: String(line)) {
                entries.append(RawEntry(header: header, body: header.rest))
            } else if !entries.isEmpty {
                // Linha sem data é continuação da mensagem anterior.
                entries[entries.count - 1].body += "\n" + line
            }
        }
        guard !entries.isEmpty else { throw ParseError.noMessages }

        let dayFirst = isDayFirst(entries.map(\.header))
        var messages: [Message] = []
        var systemEvents: [SystemEvent] = []
        var calls: [Call] = []

        for entry in entries {
            guard let date = entry.header.date(dayFirst: dayFirst) else { continue }
            switch classify(entry.body) {
            case .message(let author, let text, let kind):
                messages.append(Message(date: date, author: author, text: text, kind: kind))
            case .call(let caller, let isVideo, let duration, let isMissed):
                calls.append(Call(date: date, caller: caller, isVideo: isVideo, duration: duration, isMissed: isMissed))
            case .system(let text):
                systemEvents.append(SystemEvent(date: date, text: text))
            }
        }
        guard !messages.isEmpty else { throw ParseError.noMessages }

        let exporter = messages.first {
            $0.kind == .deleted && ChatMarkers.deletedByExporter.contains($0.text.lowercased().trimmingCharacters(in: .punctuationCharacters))
        }?.author
        let membershipChanges = systemEvents.flatMap(membershipChanges(in:))
        let authorCount = Set(messages.map(\.author)).count
        let createdGroup = systemEvents.contains {
            let text = $0.text.lowercased()
            return text.contains("created group") || text.contains("criou o grupo") || text.contains("criou este grupo")
        }

        return Chat(
            messages: messages,
            systemEvents: systemEvents,
            calls: calls,
            membershipChanges: membershipChanges,
            isGroup: authorCount > 2 || createdGroup || !membershipChanges.isEmpty,
            exporter: exporter,
            title: ChatTitle.fromSystemEvents(systemEvents)
        )
    }

    // MARK: - Cabeçalho da linha

    private struct RawEntry {
        let header: Header
        var body: String
    }

    /// "[28/10/26, 16:05:12] Ana: oi" (iPhone) ou "28/10/2026 16:05 - Ana: oi" (Android).
    private struct Header {
        let first: Int, second: Int, year: Int
        let hour: Int, minute: Int, secondOfMinute: Int
        let meridiem: Character?
        /// Tudo depois da data: "Ana: oi" ou um aviso do sistema.
        let rest: String

        private static let time = #"(\d{1,2}):(\d{2})(?::(\d{2}))?(?:[ \x{202F}\x{00A0}]?([AaPp])\.? ?[Mm]\.?)?"#
        private static let date = #"(\d{1,2})[/.-](\d{1,2})[/.-](\d{2,4}),? "#
        private static let iPhone = try! NSRegularExpression(pattern: #"^\["# + date + time + #"\] (.*)$"#)
        private static let android = try! NSRegularExpression(pattern: "^" + date + time + #" - (.*)$"#)

        init?(line: String) {
            let trimmed = String(line.drop { ChatMarkers.invisibleCharacters.contains($0) })
            let range = NSRange(trimmed.startIndex..., in: trimmed)
            guard let match = Self.iPhone.firstMatch(in: trimmed, range: range)
                    ?? Self.android.firstMatch(in: trimmed, range: range) else { return nil }

            func group(_ index: Int) -> String? {
                Range(match.range(at: index), in: trimmed).map { String(trimmed[$0]) }
            }
            first = Int(group(1)!)!
            second = Int(group(2)!)!
            year = Int(group(3)!)!
            hour = Int(group(4)!)!
            minute = Int(group(5)!)!
            secondOfMinute = group(6).flatMap(Int.init) ?? 0
            meridiem = group(7)?.lowercased().first
            rest = group(8)!
        }

        func date(dayFirst: Bool) -> Date? {
            var hour24 = hour
            if meridiem == "p", hour < 12 { hour24 += 12 }
            if meridiem == "a", hour == 12 { hour24 = 0 }

            let components = DateComponents(
                year: year < 100 ? 2000 + year : year,
                month: dayFirst ? second : first,
                day: dayFirst ? first : second,
                hour: hour24, minute: minute, second: secondOfMinute
            )
            guard components.isValidDate(in: ChatCalendar.calendar) else { return nil }
            return ChatCalendar.calendar.date(from: components)
        }
    }

    /// Brasil usa dia/mês; aparelhos em inglês dos EUA usam mês/dia.
    /// Se algum dos dois campos passar de 12, ele só pode ser o dia.
    private static func isDayFirst(_ headers: [Header]) -> Bool {
        if headers.contains(where: { $0.first > 12 }) { return true }
        if headers.contains(where: { $0.second > 12 }) { return false }
        return true
    }

    // MARK: - Tipo de cada linha

    private enum Entry {
        case message(author: String, text: String, kind: Message.Kind)
        case call(caller: String, isVideo: Bool, duration: TimeInterval?, isMissed: Bool)
        case system(String)
    }

    private static func classify(_ body: String) -> Entry {
        // O iPhone grava avisos sem autor começando com o caractere invisível U+200E.
        guard body.first != ChatMarkers.leftToRightMark,
              let (author, rawText) = splitAuthor(body) else {
            return .system(clean(body))
        }

        let text = clean(rawText)
        let lower = text.lowercased()
        let lowerNoPeriod = lower.hasSuffix(".") ? String(lower.dropLast()) : lower
        // Mídias, chamadas e avisos do iPhone também começam com U+200E.
        let isMarked = rawText.first == ChatMarkers.leftToRightMark

        if let media = ChatMarkers.media[lowerNoPeriod] {
            return .message(author: author, text: text, kind: .media(media))
        }
        if ChatMarkers.documentSuffixes.contains(where: { lower.hasSuffix($0) }) {
            return .message(author: author, text: text, kind: .media(.document))
        }
        if ChatMarkers.locationPrefixes.contains(where: { lower.hasPrefix($0) }) {
            return .message(author: author, text: text, kind: .media(.location))
        }
        if ChatMarkers.deleted.contains(lowerNoPeriod) {
            return .message(author: author, text: text, kind: .deleted)
        }
        if isMarked, ChatMarkers.callPrefixes.contains(where: { lower.hasPrefix($0) }) {
            return .call(
                caller: author,
                isVideo: ChatMarkers.videoCallFragments.contains(where: { lower.contains($0) }),
                duration: callDuration(lower),
                isMissed: ChatMarkers.missedCallFragments.contains(where: { lower.contains($0) })
            )
        }
        if isMarked, ChatMarkers.systemFragments.contains(where: { lower.contains($0) }) {
            return .system(text)
        }
        return .message(author: author, text: text, kind: .text)
    }

    private static let callDurationRegex = try! NSRegularExpression(pattern: ChatMarkers.callDurationPattern)

    /// "voice call. 12 min" → 720. nil quando não há duração ("no answer", "ringing"…).
    private static func callDuration(_ text: String) -> TimeInterval? {
        let matches = callDurationRegex.matches(in: text, range: NSRange(text.startIndex..., in: text))
        guard !matches.isEmpty else { return nil }
        return matches.reduce(0) { total, match in
            let value = Range(match.range(at: 1), in: text).flatMap { Double(text[$0]) } ?? 0
            let unit = Range(match.range(at: 2), in: text).map { text[$0] } ?? ""
            switch unit {
            case "min", "mins": return total + value * 60
            case "hr", "hrs", "h", "hora", "horas": return total + value * 3600
            default: return total + value
            }
        }
    }

    private static func splitAuthor(_ body: String) -> (String, String)? {
        let author: Substring, text: Substring
        if let separator = body.range(of: ": ") {
            author = body[..<separator.lowerBound]
            text = body[separator.upperBound...]
        } else if body.hasSuffix(":") {
            author = body.dropLast()
            text = ""
        } else {
            return nil
        }
        let name = clean(String(author))
        return name.isEmpty ? nil : (name, String(text))
    }

    private static func clean(_ text: String) -> String {
        var result = String(text.filter { !ChatMarkers.invisibleCharacters.contains($0) })
        for marker in ChatMarkers.editedMarkers {
            result = result.replacingOccurrences(of: marker, with: "", options: .caseInsensitive)
        }
        return result.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    // MARK: - Entradas e saídas

    private static let joinRegexes = ChatMarkers.joinPatterns.map { try! NSRegularExpression(pattern: $0, options: .caseInsensitive) }
    private static let leaveRegexes = ChatMarkers.leavePatterns.map { try! NSRegularExpression(pattern: $0, options: .caseInsensitive) }

    private static func membershipChanges(in event: SystemEvent) -> [MembershipChange] {
        let text = event.text
        let range = NSRange(text.startIndex..., in: text)
        for (regexes, joined) in [(joinRegexes, true), (leaveRegexes, false)] {
            for regex in regexes {
                guard let match = regex.firstMatch(in: text, range: range),
                      let names = Range(match.range(at: 2), in: text) else { continue }
                return splitNames(String(text[names])).map {
                    MembershipChange(date: event.date, name: $0, joined: joined)
                }
            }
        }
        return []
    }

    /// "Ana, Bia e Carla" → ["Ana", "Bia", "Carla"]. Ignora "você", que é quem exportou.
    private static func splitNames(_ list: String) -> [String] {
        list.replacingOccurrences(of: " and ", with: ", ")
            .replacingOccurrences(of: " e ", with: ", ")
            .components(separatedBy: ", ")
            .map { $0.trimmingCharacters(in: CharacterSet(charactersIn: " .")) }
            .filter { !$0.isEmpty && !["you", "você", "voce"].contains($0.lowercased()) }
    }
}

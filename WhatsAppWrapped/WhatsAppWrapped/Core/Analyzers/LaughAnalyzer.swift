//
//  LaughAnalyzer.swift
//  WhatsAppWrapped
//
//  Slide 09: encontra risadas (kkk, haha, rsrs, 😂…) e conta por pessoa e por tipo.
//

import Foundation

/// Slide 09: quantas vezes riram.
nonisolated enum LaughAnalyzer {
    /// kkk (aceita uma letra antes, como "jkkk", e "j" no meio, como "kkkjkk"), haha/hehe/huahua,
    /// rsrs, ksks, kaka, lol, lmao e os emojis de risada.
    private static let regex = try! NSRegularExpression(
        pattern: #"(?<!\p{L})(\p{L}?k{3,}[kj]*|a?(?:h[aeiu]{1,2}){2,}h?|(?:rs){2,}|(?:ks){2,}k?|(?:ka){2,}k?|lol|lmao)(?!\p{L})|[😂🤣😹😆]"#
    )

    static func analyze(_ messages: [Message]) -> LaughStats {
        var byPerson: [String: Int] = [:]
        var byType: [String: Int] = [:]
        var total = 0

        for message in messages where message.isText {
            let laughs = matches(in: message.text)
            guard !laughs.isEmpty else { continue }
            // Uma mensagem com várias risadas conta como 1 risada.
            total += 1
            byPerson[message.author, default: 0] += 1
            for laugh in laughs {
                byType[normalize(laugh), default: 0] += 1
            }
        }

        let types = byType
            .map { LaughStats.TypeCount(laugh: $0.key, count: $0.value) }
            .sorted { ($0.count, $1.laugh) > ($1.count, $0.laugh) }
        return LaughStats(total: total, byPerson: PersonCount.ranking(byPerson), byType: Array(types.prefix(10)))
    }

    /// Se a palavra inteira é uma risada. Usado para tirar risadas das palavras favoritas.
    static func isLaugh(_ word: String) -> Bool {
        let lower = word.lowercased()
        guard let match = regex.firstMatch(in: lower, range: NSRange(lower.startIndex..., in: lower)) else { return false }
        return match.range.length == (lower as NSString).length
    }

    private static func matches(in text: String) -> [String] {
        let lower = text.lowercased()
        return regex.matches(in: lower, range: NSRange(lower.startIndex..., in: lower)).compactMap {
            Range($0.range, in: lower).map { String(lower[$0]) }
        }
    }

    /// "kkkkkk" → "kkk", "hahahah" → "haha", "rsrsrs" → "rsrs".
    private static func normalize(_ laugh: String) -> String {
        if laugh.unicodeScalars.first?.properties.isEmojiPresentation == true || ["lol", "lmao"].contains(laugh) {
            return laugh
        }
        if laugh.hasPrefix("rs") { return "rsrs" }
        if laugh.hasPrefix("ks") { return "ksks" }
        if laugh.hasPrefix("ka") { return "kaka" }
        if laugh.filter({ $0 == "k" }).count >= 3 { return "kkk" }

        let vowels = Set(laugh.filter { "aeiu".contains($0) })
        if vowels == ["e"] { return "hehe" }
        if vowels == ["i"] { return "hihi" }
        if vowels.contains("u") { return "huahua" }
        return "haha"
    }
}

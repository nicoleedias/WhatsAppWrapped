//
//  WordAnalyzer.swift
//  WhatsAppWrapped
//
//  Slides 12–13: palavras mais usadas (sem stopwords, links e nomes) e perguntas do quiz.
//

import Foundation

/// Slides 12 (quiz) e 13 (palavras favoritas).
/// Calcula as frequências; a IA só escolhe quais palavras são mais divertidas de mostrar.
nonisolated enum WordAnalyzer {
    private static let urlRegex = try! NSRegularExpression(pattern: #"(?:https?://|www\.)\S+"#, options: .caseInsensitive)
    /// Abaixo disso, a palavra aparece pouco demais para virar pergunta do quiz.
    private static let quizMinimumCount = 5

    /// `participants` em ordem de atividade, para escolher as opções do quiz.
    static func analyze(_ messages: [Message], participants: [String]) -> WordStats {
        let names = Set(participants.flatMap(words(in:)))
        var overall: [String: Int] = [:]
        var byPerson: [String: [String: Int]] = [:]

        for message in messages where message.isText {
            for word in words(in: message.text) where isRelevant(word, names: names) {
                overall[word, default: 0] += 1
                byPerson[message.author, default: [:]][word, default: 0] += 1
            }
        }

        let personWords = participants.compactMap { name in
            byPerson[name].map { WordStats.PersonWords(name: name, words: top($0, limit: 15)) }
        }
        return WordStats(
            top: top(overall, limit: 30),
            byPerson: personWords,
            quiz: quiz(overall: overall, byPerson: byPerson, participants: participants)
        )
    }

    /// Minúsculas, sem links, pontuação e números.
    static func words(in text: String) -> [String] {
        let lower = text.lowercased()
        let withoutLinks = urlRegex.stringByReplacingMatches(
            in: lower, range: NSRange(lower.startIndex..., in: lower), withTemplate: " "
        )
        return withoutLinks.split { !$0.isLetter }.map(String.init)
    }

    private static func isRelevant(_ word: String, names: Set<String>) -> Bool {
        word.count >= 3
            && Set(word).count > 1 // "aaaa", "sss"
            && !ChatMarkers.stopwords.contains(word)
            && !names.contains(word)
            && !LaughAnalyzer.isLaugh(word)
    }

    private static func top(_ counts: [String: Int], limit: Int) -> [WordStats.WordCount] {
        counts
            .sorted { ($0.value, $1.key) > ($1.value, $0.key) }
            .prefix(limit)
            .map { WordStats.WordCount(word: $0.key, count: $0.value) }
    }

    /// Palavras em que a fatia de uma pessoa é bem maior do que a fatia dela no total de palavras.
    private static func quiz(overall: [String: Int], byPerson: [String: [String: Int]], participants: [String]) -> [WordStats.QuizQuestion] {
        guard participants.count >= 2 else { return [] }
        let totalWords = Double(overall.values.reduce(0, +))
        guard totalWords > 0 else { return [] }
        let share = byPerson.mapValues { Double($0.values.reduce(0, +)) / totalWords }

        struct Candidate { let word: String, person: String, count: Int, score: Double }
        var candidates: [Candidate] = []
        for (word, total) in overall where total >= quizMinimumCount {
            for (person, counts) in byPerson {
                guard let count = counts[word], count >= quizMinimumCount else { continue }
                let score = Double(count) / Double(total) - (share[person] ?? 0)
                if score > 0 { candidates.append(Candidate(word: word, person: person, count: count, score: score)) }
            }
        }
        candidates.sort { ($0.score, $0.count, $1.word) > ($1.score, $1.count, $0.word) }

        // Primeiro uma pergunta por pessoa, para a resposta não ser sempre a mesma.
        var chosen: [Candidate] = []
        var usedPeople = Set<String>()
        for candidate in candidates where chosen.count < 3 && usedPeople.insert(candidate.person).inserted {
            chosen.append(candidate)
        }
        for candidate in candidates where chosen.count < 3 && !chosen.contains(where: { $0.word == candidate.word }) {
            chosen.append(candidate)
        }

        return chosen.map { candidate in
            let others = participants.filter { $0 != candidate.person }.prefix(3)
            return WordStats.QuizQuestion(
                word: candidate.word,
                options: ([candidate.person] + others).sorted(),
                answer: candidate.person,
                count: candidate.count
            )
        }
    }
}

//
//  WordStats.swift
//  WhatsAppWrapped
//
//  Slides 12–13: palavras mais usadas e o quiz de "quem fala essa palavra".
//

import Foundation

nonisolated struct WordStats: Codable, Sendable {
    /// Palavras mais usadas, sem stopwords, risadas e nomes. Top 30, para a IA escolher as melhores.
    let top: [WordCount]
    /// Top 15 de cada pessoa.
    let byPerson: [PersonWords]
    /// Palavras que uma pessoa usa muito mais que as outras. Até 3.
    let quiz: [QuizQuestion]

    struct WordCount: Codable, Sendable, Hashable {
        let word: String
        let count: Int
    }

    struct PersonWords: Codable, Sendable {
        let name: String
        let words: [WordCount]
    }

    struct QuizQuestion: Codable, Sendable {
        let word: String
        /// Até 4 participantes, incluindo a resposta, em ordem alfabética.
        let options: [String]
        let answer: String
        /// Quantas vezes a resposta usou a palavra.
        let count: Int
    }
}

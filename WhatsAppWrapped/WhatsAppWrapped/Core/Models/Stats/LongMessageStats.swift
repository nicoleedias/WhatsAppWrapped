//
//  LongMessageStats.swift
//  WhatsAppWrapped
//
//  Slide 18: tamanho médio das mensagens e o maior textão.
//

import Foundation

nonisolated struct LongMessageStats: Codable, Sendable {
    /// Média de caracteres por mensagem de texto, arredondada.
    let averageLengthByPerson: [PersonCount]
    let longest: Longest?
    /// Total de caracteres digitados por pessoa. nil em retrospectivas antigas.
    var totalCharactersByPerson: [PersonCount]? = nil

    struct Longest: Codable, Sendable {
        let name: String
        let length: Int
        let date: Date
        let text: String
    }
}

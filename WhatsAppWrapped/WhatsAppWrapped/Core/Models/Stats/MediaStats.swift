//
//  MediaStats.swift
//  WhatsAppWrapped
//
//  Slides 17, 17d e 17e: áudios, fotos e figurinhas.
//

import Foundation

nonisolated struct MediaStats: Codable, Sendable {
    /// Todas as mídias (fotos, áudios, vídeos, figurinhas…).
    let total: Int
    /// Campeão de mídias.
    let byPerson: [PersonCount]
    // nil quando o arquivo não diz o tipo da mídia (exportação do Android só escreve "<Mídia oculta>").
    let audios: MediaTypeStats?     // 17
    let photos: MediaTypeStats?     // 17d
    let stickers: MediaTypeStats?   // 17e
}

nonisolated struct MediaTypeStats: Codable, Sendable {
    let total: Int
    let byPerson: [PersonCount]
    /// Ex.: "25 de dezembro: 64 fotos num dia só". nil se não houver nenhuma.
    let busiestDay: DayCount?
    /// Meses do período em ordem cronológica, incluindo os meses com 0.
    let byMonth: [MonthCount]
    /// Ex.: "1 figurinha a cada 90 mensagens". nil se não houver nenhuma.
    let messagesPerItem: Int?

    struct DayCount: Codable, Sendable, Hashable {
        let date: Date
        let count: Int
    }

    struct MonthCount: Codable, Sendable, Hashable {
        /// Primeiro dia do mês.
        let month: Date
        let count: Int
    }
}

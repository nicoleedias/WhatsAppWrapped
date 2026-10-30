//
//  HourStats.swift
//  WhatsAppWrapped
//
//  Slide 16: mensagens por hora e período do dia favorito.
//

import Foundation

nonisolated struct HourStats: Codable, Sendable {
    /// 24 posições: mensagens das 0h às 23h.
    let byHour: [Int]
    let peakHour: Int
    let favoritePartOfDay: PartOfDay

    enum PartOfDay: String, Codable, Sendable, CaseIterable {
        case lateNight  // madrugada, 0–5h
        case morning    // 6–11h
        case afternoon  // 12–17h
        case night      // 18–23h

        init(hour: Int) {
            switch hour {
            case 0..<6: self = .lateNight
            case 6..<12: self = .morning
            case 12..<18: self = .afternoon
            default: self = .night
            }
        }
    }
}

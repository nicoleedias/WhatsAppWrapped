//
//  ChatCalendar.swift
//  WhatsAppWrapped
//
//  Calendário em UTC usado em todo o app, para que dias e horas não mudem com o fuso do aparelho.
//

import Foundation

/// O arquivo traz o horário local de quem exportou, sem fuso.
/// Guardamos as datas em UTC para que dias e horas nunca mudem com o fuso
/// ou o horário de verão do aparelho. Formate sempre com `ChatCalendar.timeZone`.
nonisolated enum ChatCalendar {
    static let timeZone = TimeZone(identifier: "UTC")!

    static let calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone
        return calendar
    }()

    static func startOfDay(_ date: Date) -> Date {
        calendar.startOfDay(for: date)
    }

    static func startOfMonth(_ date: Date) -> Date {
        calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
    }

    static func hour(_ date: Date) -> Int {
        calendar.component(.hour, from: date)
    }

    static func adding(days: Int, to date: Date) -> Date {
        calendar.date(byAdding: .day, value: days, to: date)!
    }
}

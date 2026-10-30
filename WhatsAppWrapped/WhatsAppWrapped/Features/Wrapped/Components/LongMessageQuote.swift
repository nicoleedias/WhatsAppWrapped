//
//  LongMessageQuote.swift
//  WhatsAppWrapped
//
//  Slide 18: o começo do maior textão num balão creme de mensagem enviada (pontinha à direita), cortado
//  em cinco linhas com "…", e embaixo o tamanho e quando foi mandado.
//

import SwiftUI

struct LongMessageQuote: View {
    let text: String
    /// "1.284 caracteres · 14 de março, 2h13".
    let detail: String

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text(text)
                .textStyle(.bodyM)
                .lineLimit(5)
                .truncationMode(.tail)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(24)
                .background(.cream, in: BubbleShape(radius: 32, tail: .bottomTrailing))
                .foregroundStyle(.ink)
                .popEntrance(delay: 0.3, from: 0.92)
            Text(detail)
                .textStyle(TextStyle(size: 14, weight: .medium, relativeTo: .subheadline))
                .entrance(delay: 0.6)
        }
    }

    /// "1.284 caracteres · 14 de março, 2h13", no fuso da conversa.
    static func detail(length: Int, date: Date) -> String {
        let style = Date.FormatStyle(
            locale: Locale(identifier: "pt_BR"),
            calendar: ChatCalendar.calendar,
            timeZone: ChatCalendar.timeZone
        )
        let day = date.formatted(style.day().month(.wide))
        let components = ChatCalendar.calendar.dateComponents([.hour, .minute], from: date)
        let time = "\(components.hour ?? 0)h\(String(format: "%02d", components.minute ?? 0))"
        return "\(length.formatted()) caracteres · \(day), \(time)"
    }
}

#Preview {
    LongMessageQuote(
        text: "Eu tava pensando aqui sobre ontem e acho que a gente precisa conversar sobre a forma como a gente escolhe o restaurante de sexta, porque toda vez é a mesma coisa e a gente acaba indo no mesmo lugar de sempre",
        detail: "1.284 caracteres · 14 de março, 2h13"
    )
    .padding(32)
    .background(.butter)
}

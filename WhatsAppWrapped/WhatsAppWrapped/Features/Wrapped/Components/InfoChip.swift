//
//  InfoChip.swift
//  WhatsAppWrapped
//
//  Etiqueta com emoji + curiosidade em negrito: "📅 25 de dezembro: 64 fotos num dia só" (creme, 17d)
//  e "💬 1 figurinha a cada 90 mensagens" (tinta, 17e). Só ocupa a largura do texto.
//

import SwiftUI

struct InfoChip: View {
    enum Style {
        case light, dark

        var background: Color { self == .light ? .cream : .ink }
        var foreground: Color { self == .light ? .ink : .cream }
    }

    let emoji: String
    let text: String
    var style: Style = .light

    var body: some View {
        HStack(spacing: 8) {
            Text(emoji)
                .textStyle(.bodyL)
                .accessibilityHidden(true)
            Text(text)
                .textStyle(.bodySBold)
        }
        .foregroundStyle(style.foreground)
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(style.background, in: .rect(cornerRadius: 20))
        .entrance(delay: 0.9)
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 24) {
        InfoChip(emoji: "📅", text: "25 de dezembro: 64 fotos num dia só")
        InfoChip(emoji: "💬", text: "1 figurinha a cada 90 mensagens", style: .dark)
    }
    .padding(32)
    .background(.lime)
}

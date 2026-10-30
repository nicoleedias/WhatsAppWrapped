//
//  ChampionEmoji.swift
//  WhatsAppWrapped
//
//  Slide 11: o emoji #1 em 160 pt, centralizado numa área de 260 pt de altura (na frente dos arcos),
//  entrando com pop depois que os arcos crescem.
//

import SwiftUI

struct ChampionEmoji: View {
    let emoji: String
    /// Quantas vezes foi usado, para o VoiceOver.
    let count: Int

    var body: some View {
        Text(emoji)
            .font(.system(size: 160))
            .frame(maxWidth: .infinity, minHeight: 260)
            .popEntrance(delay: 0.3, from: 0.4)
            .accessibilityLabel("Emoji mais usado: \(emoji), \(count) vezes")
    }
}

#Preview {
    ZStack {
        Color.rose
        ConcentricDecoration.emojiChampion
        ChampionEmoji(emoji: "😭", count: 1365)
            .position(x: 196.5, y: 380)
    }
    .ignoresSafeArea()
}

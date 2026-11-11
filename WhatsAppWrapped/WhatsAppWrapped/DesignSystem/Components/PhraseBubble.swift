//
//  PhraseBubble.swift
//  WhatsAppWrapped
//
//  Balão da frase gerada pela IA: emoji + frase curta (até 2 linhas). Claro em fundos claros,
//  translúcido em fundos escuros e um tom mais escuro no fundo creme (`Backdrop.phraseBubble`).
//  Entra 0,9 s depois do número, com pop.
//

import SwiftUI

struct PhraseBubble: View {
    let emoji: String
    let text: String
    @Environment(\.backdrop) private var backdrop
    @Environment(\.isStoryPoster) private var isStoryPoster

    var body: some View {
        HStack(spacing: 12) {
            Text(emoji)
                .textStyle(.title)
                .accessibilityHidden(true)
            Text(text)
                .textStyle(.bodyS)
                .lineLimit(2)
                // No story, a frase nunca é cortada: o slide mais cheio (fotos) usa a sobra da margem de baixo.
                .fixedSize(horizontal: false, vertical: isStoryPoster)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .foregroundStyle(backdrop.foreground)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(minHeight: 48)
        .background(backdrop.phraseBubble, in: BubbleShape(radius: 20, tail: .bottomLeading))
        .popEntrance()
    }
}

#Preview {
    VStack {
        PhraseBubble(emoji: "📖", text: "Já dá pra escrever um livro só com essa conversa.")
            .padding().background(.coral).environment(\.backdrop, .coral)
        PhraseBubble(emoji: "🦉", text: "Já dá pra escrever um livro só com essa conversa.")
            .padding().background(.plum).environment(\.backdrop, .plum)
    }
}

//
//  StickersSlide.swift
//  WhatsAppWrapped
//
//  17e: figurinhas trocadas, a frequência e quem mandou mais (numa conversa a dois), sobre lima.
//

import SwiftUI

struct StickersSlide: StorySlide {
    static let label = "Figurinhas"
    static let phraseSlide: PhraseSlide? = .stickers

    let stickers: WrappedSlide.Stickers

    var body: some View {
        ScreenContainer(backdrop: .lime) {
            SlideHeader()
            Text("Vocês trocaram")
                .textStyle(.title)
                .entrance()
            StickerCountCard(count: stickers.count)
            if let frequency = stickers.frequency {
                InfoChip(emoji: "💬", text: frequency, style: .dark)
            }
            if let split = stickers.split {
                SplitBar(leading: split.leading, trailing: split.trailing)
            }
            SlidePhraseBubble()
            Spacer(minLength: 0)
        }
        .slideFooter()
    }
}

#Preview {
    StickersSlide(
        stickers: .init(
            count: 341,
            frequency: "1 figurinha a cada 90 mensagens",
            split: (.init(name: "Você", count: 268), .init(name: "Bia", count: 73))
        )
    )
    .slidePreview(phrase: .init(emoji: "🧸", text: "Você responde até pergunta séria com figurinha."))
}

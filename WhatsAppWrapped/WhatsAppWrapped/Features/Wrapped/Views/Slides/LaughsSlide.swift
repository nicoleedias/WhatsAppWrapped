//
//  LaughsSlide.swift
//  WhatsAppWrapped
//
//  09: quantas vezes vocês riram, sobre manteiga, com a estrela coral e o 😂 na base.
//

import SwiftUI

struct LaughsSlide: StorySlide {
    static let label = "Risadas"
    static let phraseSlide: PhraseSlide? = .laughs

    let headline: WrappedSlide.Headline

    var body: some View {
        ScreenContainer(backdrop: .butter) {
            BurstDecoration.laughs
            DecorationEmoji.laughs()
        } content: {
            SlideHeader()
            HeadlineStat(intro: headline.intro, value: headline.value, caption: headline.caption)
            SlidePhraseBubble()
            Spacer(minLength: 0)
        }
        .slideFooter()
    }
}

#Preview {
    LaughsSlide(
        headline: .init(intro: "Vocês riram", value: "2.847", caption: "vezes")
    )
    .slidePreview(phrase: .init(emoji: "😂", text: "Seu abdômen agradece."))
}

//
//  StreakSlide.swift
//  WhatsAppWrapped
//
//  15: maior sequência de dias, em manteiga sobre ameixa, com a estrela e o 🔥 na base.
//

import SwiftUI

struct StreakSlide: StorySlide {
    static let label = "Sequência"
    static let phraseSlide: PhraseSlide? = .streak

    let headline: WrappedSlide.Headline

    var body: some View {
        ScreenContainer(backdrop: .plum) {
            BurstDecoration.streak
            DecorationEmoji.streak()
        } content: {
            SlideHeader()
            HeadlineStat(
                value: headline.value,
                caption: headline.caption,
                valueStyle: .numberGiant,
                captionStyle: .slideSubtitle,
                valueColor: .butter
            )
            SlidePhraseBubble()
            Spacer(minLength: 0)
        }
        .slideFooter()
    }
}

#Preview {
    StreakSlide(
        headline: .init(value: "95", caption: "dias seguidos trocando mensagem")
    )
    .slidePreview(phrase: .init(emoji: "🦉", text: "Nem o Duolingo te pressiona tanto."))
}

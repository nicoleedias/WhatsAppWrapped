//
//  EmojiChampionSlide.swift
//  WhatsAppWrapped
//
//  11: o emoji mais usado, grande, sobre rosa com os círculos crescendo atrás.
//

import SwiftUI

struct EmojiChampionSlide: StorySlide {
    static let label = "Emoji"
    static let phraseSlide: PhraseSlide? = .emojis

    let champion: WrappedSlide.EmojiChampion

    var body: some View {
        ScreenContainer(backdrop: .rose) {
            ConcentricDecoration.emojiChampion
        } content: {
            SlideHeader()
            Text("O emoji preferido de vocês é")
                .textStyle(.slideSubtitle)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .entrance()
            ChampionEmoji(emoji: champion.emoji, count: champion.count)
            Spacer(minLength: 0)
            Text(champion.countText)
                .textStyle(.numberMedium, minimumScale: 0.5)
                .frame(maxWidth: .infinity)
                .entrance(delay: 0.5)
            SlidePhraseBubble()
        }
        .slideFooter()
    }
}

#Preview {
    EmojiChampionSlide(
        champion: .init(emoji: "😭", count: 1365, countText: "1.365 vezes")
    )
    .slidePreview(phrase: .init(emoji: "©️", text: "Devia ganhar direitos autorais."))
}

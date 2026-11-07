//
//  AudiosSlide.swift
//  WhatsAppWrapped
//
//  17: quantos áudios você mandou e a comparação entre quem mais manda, sobre rosa.
//

import SwiftUI

struct AudiosSlide: StorySlide {
    static let label = "Áudios"
    static let phraseSlide: PhraseSlide? = .audios

    let audios: WrappedSlide.Audios

    var body: some View {
        ScreenContainer(backdrop: .rose) {
            SlideHeader()
            HeadlineStat(intro: audios.headline.intro, value: audios.headline.value, caption: audios.headline.caption)
            if let comparison = audios.comparison {
                AudioComparison(first: comparison.first, second: comparison.second)
            }
            SlidePhraseBubble()
            Spacer(minLength: 0)
        }
        .slideFooter()
    }
}

#Preview {
    AudiosSlide(
        audios: .init(
            headline: .init(intro: "Vocês trocaram", value: "508", caption: "áudios"),
            comparison: (.init(name: "Você", duration: "412 áudios"), .init(name: "Bia", duration: "96 áudios"))
        )
    )
    .slidePreview(phrase: .init(emoji: "🎙️", text: "Você faz podcast e nem sabia."))
}

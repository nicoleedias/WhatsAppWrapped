//
//  WordsSlide.swift
//  WhatsAppWrapped
//
//  13: as três palavras mais usadas, sobre lima com as ondas na base.
//

import SwiftUI

struct WordsSlide: StorySlide {
    static let label = "Palavras"
    static let phraseSlide: PhraseSlide? = .words

    let words: [WordStats.WordCount]

    var body: some View {
        ScreenContainer(backdrop: .lime) {
            WavesDecoration.words
        } content: {
            SlideHeader()
            Text("As palavras favoritas de vocês")
                .textStyle(.slideTitle)
                .accessibilityAddTraits(.isHeader)
                .entrance()
            WordRanking(words: words)
            Spacer(minLength: 0)
            SlidePhraseBubble()
        }
        .slideFooter()
    }
}

#Preview {
    WordsSlide(
        words: [.init(word: "kkkkk", count: 2104), .init(word: "então", count: 1310), .init(word: "mds", count: 987)]
    )
    .slidePreview(phrase: .init(emoji: "🙃", text: "Seu vocabulário é 30% risada e 70% “então…”."))
}

//
//  LongMessageSlide.swift
//  WhatsAppWrapped
//
//  18: o maior textão, sobre manteiga com as ondas na base. Nas retrospectivas salvas o texto não é
//  guardado, então só aparecem o tamanho e a data.
//

import SwiftUI

struct LongMessageSlide: StorySlide {
    static let label = "Textão"
    static let phraseSlide: PhraseSlide? = .longMessages

    let message: WrappedSlide.LongMessage

    var body: some View {
        ScreenContainer(backdrop: .butter) {
            WavesDecoration.longMessage
        } content: {
            SlideHeader()
            Text("O maior textão do ano foi...")
                .textStyle(.slideTitle)
                .accessibilityAddTraits(.isHeader)
                .entrance()
            if let text = message.text {
                LongMessageQuote(text: text, detail: message.detail)
            } else {
                Text(message.detail)
                    .textStyle(.bodyL)
                    .entrance(delay: 0.3)
            }
            SlidePhraseBubble()
            Spacer(minLength: 0)
        }
        .slideFooter()
    }
}

#Preview {
    LongMessageSlide(
        message: .init(
            text: "Eu tava pensando aqui sobre ontem e acho que a gente precisa conversar sobre a forma como a gente escolhe o restaurante de sexta",
            detail: "Bia · 1.284 caracteres · 14 de março, 02:13"
        )
    )
    .slidePreview(phrase: .init(emoji: "🎤", text: "Isso foi um TED Talk, não uma mensagem."))
}

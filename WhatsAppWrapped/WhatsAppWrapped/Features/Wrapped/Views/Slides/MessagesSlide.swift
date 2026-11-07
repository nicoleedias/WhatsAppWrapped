//
//  MessagesSlide.swift
//  WhatsAppWrapped
//
//  08: total de mensagens sobre coral, com as ondas na base.
//

import SwiftUI

struct MessagesSlide: StorySlide {
    static let label = "Mensagens"
    static let phraseSlide: PhraseSlide? = .messages

    let headline: WrappedSlide.Headline

    var body: some View {
        ScreenContainer(backdrop: .coral) {
            WavesDecoration.messages
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
    MessagesSlide(
        headline: .init(intro: "Vocês trocaram", value: "30.597", caption: "mensagens")
    )
    .slidePreview(phrase: .init(emoji: "📖", text: "Já dá pra escrever um livro só com essa conversa."))
}

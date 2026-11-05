//
//  ResponseTimeSlide.swift
//  WhatsAppWrapped
//
//  14a–14d: os dois tempos de resposta. O mais lento fica "digitando…" por um tempo e só então aparece,
//  junto com a frase da IA.
//

import SwiftUI

struct ResponseTimeSlide: StorySlide {
    static let label = "Resposta"
    static let phraseSlide: PhraseSlide? = .responseTime

    let duel: WrappedSlide.ResponseDuel

    /// 14a–14c antes de mostrar o tempo (14d).
    static let typingDuration: Duration = .seconds(2.4)

    @State private var isRevealed = false

    var body: some View {
        ScreenContainer(backdrop: .cream) {
            ConcentricDecoration.responseTime
        } content: {
            SlideHeader()
            Text(duel.title)
                .textStyle(.slideTitle)
                .accessibilityAddTraits(.isHeader)
                .entrance()
            Spacer(minLength: 0)
            ResponseTimeDuel(fastest: duel.fastest, slowest: duel.slowest, isRevealed: isRevealed)
            Spacer(minLength: 0)
            if isRevealed {
                SlidePhraseBubble()
            } else {
                Text(duel.typingCaption)
                    .textStyle(.slideCaption)
            }
        }
        .slideFooter()
        .task {
            try? await Task.sleep(for: Self.typingDuration)
            withAnimation(Motion.pop) { isRevealed = true }
        }
    }
}

#Preview {
    ResponseTimeSlide(
        duel: .init(
            title: "Quem demora mais pra responder?",
            fastest: .init(label: "Você", time: "32min"),
            slowest: .init(label: "Bia", time: "3h42min"),
            typingCaption: "Bia está digitando…"
        )
    )
    .slidePreview(phrase: .init(emoji: "🐢", text: "A Bia responde com calma de novela."))
}

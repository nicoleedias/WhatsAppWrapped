//
//  QuizSlide.swift
//  WhatsAppWrapped
//
//  12a–12b: "Adivinha!" com as palavras mais usadas da conversa. O erro balança a opção; o acerto
//  espera um instante e leva para o ranking (13).
//

import SwiftUI

struct QuizSlide: StorySlide {
    static let label = "Mini game"
    static let isShareable = false
    /// Só passa depois de acertar.
    static let requiresAnswer = true

    let quiz: WrappedSlide.Quiz
    @Environment(\.slideContext) private var context

    /// Tempo para ver o acerto antes de ir para o ranking.
    static let revealDuration: Duration = .seconds(1.2)

    @State private var lastGuess: String?

    var body: some View {
        ScreenContainer(backdrop: .lilac) {
            BurstDecoration.quiz
        } content: {
            SlideHeader()
            Text("Adivinha!")
                .textStyle(.numberLarge, minimumScale: 0.6)
                .accessibilityAddTraits(.isHeader)
                .entrance()
            Text(quiz.question)
                .textStyle(.bodyL)
                .entrance(delay: 0.1)
            QuizOptionList(options: quiz.options, answer: quiz.answer, lastGuess: lastGuess, pick: pick)
            Spacer(minLength: 0)
            Text("Toque na sua aposta")
                .textStyle(.label)
                .frame(maxWidth: .infinity)
        }
        .slideFooter()
        .task(id: lastGuess) {
            guard lastGuess == quiz.answer else { return }
            try? await Task.sleep(for: Self.revealDuration)
            guard !Task.isCancelled else { return }
            context.advance()
        }
    }

    private func pick(_ option: String) {
        lastGuess = option
    }
}

#Preview {
    QuizSlide(
        quiz: .init(question: "Qual foi a palavra mais digitada na conversa?", options: ["então", "kkkkk", "mds", "tipo"], answer: "kkkkk")
    )
    .slidePreview()
}

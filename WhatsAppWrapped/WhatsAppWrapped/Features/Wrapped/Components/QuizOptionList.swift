//
//  QuizOptionList.swift
//  WhatsAppWrapped
//
//  Slides 12a–12b: as opções do mini game em coluna (espaço de 12). Só a última aposta muda de estado:
//  errou fica marcada até a próxima tentativa; acertou trava as opções.
//

import SwiftUI

struct QuizOptionList: View {
    let options: [String]
    let answer: String
    /// Última opção tocada. nil antes da primeira aposta.
    let lastGuess: String?
    let pick: (String) -> Void

    @State private var wrongGuesses = 0

    private var isSolved: Bool { lastGuess == answer }

    var body: some View {
        VStack(spacing: 12) {
            ForEach(Array(options.enumerated()), id: \.element) { index, option in
                QuizOptionButton(title: option, state: state(of: option)) {
                    if option != answer { wrongGuesses += 1 }
                    pick(option)
                }
                .entrance(delay: 0.2 + Double(index) * Motion.cascadeStep)
            }
        }
        // Depois de acertar, as opções param de responder (sem apagar a certa, como o `.disabled` faria).
        .allowsHitTesting(!isSolved)
        .shake(trigger: wrongGuesses)
        .sensoryFeedback(.error, trigger: wrongGuesses)
        .sensoryFeedback(.success, trigger: isSolved) { _, solved in solved }
    }

    private func state(of option: String) -> QuizOptionButton.State {
        guard option == lastGuess else { return .idle }
        return option == answer ? .right : .wrong
    }
}

#Preview {
    @Previewable @State var guess: String?

    QuizOptionList(options: ["kkkkk", "então", "mds", "tipo"], answer: "kkkkk", lastGuess: guess) { guess = $0 }
        .padding(32)
        .background(.lilac)
}

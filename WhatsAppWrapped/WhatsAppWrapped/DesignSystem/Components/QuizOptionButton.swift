//
//  QuizOptionButton.swift
//  WhatsAppWrapped
//
//  Opção do quiz: a linha inteira é tocável. Errou = coral escuro + ✕; acertou = lima + ✓ (nunca só cor).
//

import SwiftUI

struct QuizOptionButton: View {
    enum State {
        case idle, wrong, right

        var symbol: String {
            switch self {
            case .idle: "arrow.right"
            case .wrong: "xmark"
            case .right: "checkmark"
            }
        }

        var background: Color {
            switch self {
            case .idle: .cream
            case .wrong: .coralDeep
            case .right: .lime
            }
        }

        var foreground: Color {
            self == .wrong ? .cream : .ink
        }

        var accessibilityValue: String {
            switch self {
            case .idle: ""
            case .wrong: "Errou"
            case .right: "Acertou"
            }
        }
    }

    let title: String
    let state: State
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .textStyle(.option)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Image(systemName: state.symbol)
                    .font(.system(size: 16, weight: .bold))
                    .contentTransition(.symbolEffect(.replace))
            }
            .foregroundStyle(state.foreground)
            .padding(.horizontal, 24)
            .frame(minHeight: 64)
            .background(state.background, in: .rect(cornerRadius: 28))
            .contentShape(.rect(cornerRadius: 28))
        }
        .buttonStyle(.plain)
        .animation(.easeOut(duration: Motion.fast), value: state)
        .accessibilityValue(state.accessibilityValue)
    }
}

#Preview {
    VStack(spacing: 12) {
        QuizOptionButton(title: "kkkkk", state: .idle) {}
        QuizOptionButton(title: "então", state: .wrong) {}
        QuizOptionButton(title: "mds", state: .right) {}
    }
    .padding(32)
    .background(.lilac)
}

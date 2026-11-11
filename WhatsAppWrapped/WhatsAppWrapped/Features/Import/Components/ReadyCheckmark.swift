//
//  ReadyCheckmark.swift
//  WhatsAppWrapped
//
//  ✓ em lima num círculo de tinta (tela 07), entrando com pop: escala 0,4 → 1,12 → 1.
//

import SwiftUI

struct ReadyCheckmark: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var hasPopped = false

    var body: some View {
        // O ✓ do Figma (Nunito ExtraBold 40) exportado como vetor: a fonte não tem esse caractere e o iOS
        // desenharia outro ✓ no lugar.
        Image(.iconCheck)
            .resizable()
            .frame(width: 30, height: 31)
            .foregroundStyle(.lime)
            .frame(width: 80, height: 80)
            .background(.ink, in: .circle)
            // Toca uma vez ao aparecer; depois fica no tamanho final.
            .keyframeAnimator(initialValue: hasPopped || reduceMotion ? 1 : 0.4, trigger: hasPopped) { content, scale in
                content.scaleEffect(scale)
            } keyframes: { _ in
                KeyframeTrack {
                    LinearKeyframe(reduceMotion ? 1 : 0.4, duration: 0)
                    CubicKeyframe(1.12, duration: Motion.slow * 0.6)
                    CubicKeyframe(1, duration: Motion.slow * 0.4)
                }
            }
            .onAppear { hasPopped = true }
            .hapticOnAppear(.success, delay: Motion.slow * 0.6)
            .accessibilityHidden(true)
    }
}

#Preview {
    ReadyCheckmark().padding().background(.lime)
}

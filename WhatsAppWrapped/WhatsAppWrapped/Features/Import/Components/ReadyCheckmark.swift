//
//  ReadyCheckmark.swift
//  WhatsAppWrapped
//
//  ✓ em lima num círculo de tinta (tela 07), entrando com pop: escala 0,4 → 1,12 → 1.
//

import SwiftUI

struct ReadyCheckmark: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        Text("✓")
            .textStyle(TextStyle(size: 40, weight: .extraBold))
            .foregroundStyle(.lime)
            .frame(width: 80, height: 80)
            .background(.ink, in: .circle)
            .keyframeAnimator(initialValue: reduceMotion ? 1 : 0.4, repeating: false) { content, scale in
                content.scaleEffect(scale)
            } keyframes: { _ in
                KeyframeTrack {
                    CubicKeyframe(1.12, duration: Motion.slow * 0.6)
                    CubicKeyframe(1, duration: Motion.slow * 0.4)
                }
            }
            .accessibilityHidden(true)
    }
}

#Preview {
    ReadyCheckmark().padding().background(.lime)
}

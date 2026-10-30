//
//  TypingBubble.swift
//  WhatsAppWrapped
//
//  Balão "digitando…" com três pontos que sobem 4 pt e acendem em onda
//  (defasagem de 0,18 s, loop de 1,2 s). Com "Reduzir movimento", os pontos ficam parados.
//  Claro (creme com pontos de tinta) no carregamento; escuro (tinta com pontos creme) no slide de resposta.
//

import SwiftUI

struct TypingBubble: View {
    enum Style {
        case light, dark

        var background: Color { self == .light ? .cream : .ink }
        var dot: Color { self == .light ? .ink : .cream }
    }

    static let loopDuration = 1.2
    static let stagger = 0.18
    static let dotCount = 3

    var style: Style = .light
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<Self.dotCount, id: \.self) { index in
                TypingDot(delay: Double(index) * Self.stagger, isAnimated: !reduceMotion)
            }
        }
        .foregroundStyle(style.dot)
        .padding(28)
        .background(style.background, in: BubbleShape(radius: 32, tail: .bottomLeading))
        .accessibilityElement()
        .accessibilityLabel("Digitando")
    }
}

private struct TypingDot: View {
    let delay: Double
    let isAnimated: Bool

    private static let riseDuration = 0.3

    var body: some View {
        Image(.typingDot)
            .renderingMode(.template)
            .keyframeAnimator(initialValue: Pose(), repeating: isAnimated) { dot, pose in
                dot.opacity(pose.opacity).offset(y: pose.y)
            } keyframes: { _ in
                let rest = TypingBubble.loopDuration - delay - Self.riseDuration * 2
                KeyframeTrack(\.y) {
                    LinearKeyframe(0, duration: delay)
                    CubicKeyframe(-4, duration: Self.riseDuration)
                    CubicKeyframe(0, duration: Self.riseDuration)
                    LinearKeyframe(0, duration: rest)
                }
                KeyframeTrack(\.opacity) {
                    LinearKeyframe(0.3, duration: delay)
                    CubicKeyframe(1, duration: Self.riseDuration)
                    CubicKeyframe(0.3, duration: Self.riseDuration)
                    LinearKeyframe(0.3, duration: rest)
                }
            }
    }

    private struct Pose {
        var y: CGFloat = 0
        var opacity = 0.3
    }
}

#Preview {
    VStack {
        TypingBubble()
        TypingBubble(style: .dark)
    }
    .padding()
    .background(.coral)
}

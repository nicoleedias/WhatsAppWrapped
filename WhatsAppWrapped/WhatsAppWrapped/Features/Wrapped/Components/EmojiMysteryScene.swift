//
//  EmojiMysteryScene.swift
//  WhatsAppWrapped
//
//  Slides 10a "Calculando…" e 10b "Quase lá…": círculo creme com "?" pulsando (1 → 1,08, duas vezes a cada 2,6 s)
//  e oito emojis em volta, subindo 18 pt e balançando em onda. No 10b os emojis ficam maiores e mais inclinados.
//  Posições do frame de 393×852 do Figma.
//

import SwiftUI

struct EmojiMysteryScene: View {
    enum Stage {
        /// 10a: emojis de 48 pt, espalhados.
        case calculating
        /// 10b: emojis de 72 pt, mais perto do círculo.
        case almostThere

        var emojiSize: CGFloat { self == .calculating ? 48 : 72 }

        /// Centro e inclinação de cada emoji, na ordem de `EmojiMysteryScene.defaultEmojis`.
        var placements: [(center: CGPoint, angle: Double)] {
            switch self {
            case .calculating:
                [
                    (CGPoint(x: 54.49, y: 628.47), 12), (CGPoint(x: 329.09, y: 577.48), -14),
                    (CGPoint(x: 123.8, y: 739.46), -10), (CGPoint(x: 276.43, y: 727.1), 8),
                    (CGPoint(x: 202.38, y: 651.36), -6), (CGPoint(x: 47.48, y: 329.09), 14),
                    (CGPoint(x: 338.47, y: 318.49), -12), (CGPoint(x: 194, y: 322.7), 0),
                ]
            case .almostThere:
                [
                    (CGPoint(x: 63.53, y: 508.24), -24), (CGPoint(x: 334.89, y: 438.69), 28),
                    (CGPoint(x: 97.51, y: 656.14), 20), (CGPoint(x: 320.53, y: 554.68), -16),
                    (CGPoint(x: 183.73, y: 562.7), 12), (CGPoint(x: 58.69, y: 224.89), -28),
                    (CGPoint(x: 348.24, y: 257.53), 24), (CGPoint(x: 174.68, y: 334.53), 16),
                ]
            }
        }
    }

    static let defaultEmojis = ["😂", "❤️", "😍", "🙏🏻", "😘", "👏🏻", "😡", "😭"]
    /// Loop da cena no Figma.
    static let loopDuration = 2.6

    let stage: Stage
    /// Até 8 emojis da conversa; completa com os do Figma se vierem menos.
    var emojis: [String] = Self.defaultEmojis

    private var shownEmojis: [String] {
        Array((emojis + Self.defaultEmojis.filter { !emojis.contains($0) }).prefix(Self.defaultEmojis.count))
    }

    var body: some View {
        FigmaCanvas { scale in
            ForEach(Array(zip(shownEmojis, stage.placements).enumerated()), id: \.offset) { index, item in
                FloatingEmoji(emoji: item.0, angle: item.1.angle, delay: Double(index) * 0.12)
                    .font(.system(size: scale.length(stage.emojiSize)))
                    .position(scale.point(item.1.center))
            }
            MysteryCircle(diameter: scale.length(160))
                .position(scale.point(CGPoint(x: 196.5, y: 460)))
        }
    }
}

/// Círculo creme com "?" em ameixa, pulsando.
private struct MysteryCircle: View {
    let diameter: CGFloat
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        Text("?")
            .font(.custom("Nunito-Bold", fixedSize: diameter * 0.52))
            .foregroundStyle(.plum)
            .frame(width: diameter, height: diameter)
            .background(.cream, in: .circle)
            .keyframeAnimator(initialValue: 1.0, repeating: !reduceMotion) { content, scale in
                content.scaleEffect(scale)
            } keyframes: { _ in
                let beat = EmojiMysteryScene.loopDuration * 0.192
                KeyframeTrack {
                    CubicKeyframe(1.08, duration: beat)
                    CubicKeyframe(1, duration: beat)
                    CubicKeyframe(1.08, duration: beat)
                    CubicKeyframe(1, duration: beat)
                    LinearKeyframe(1, duration: EmojiMysteryScene.loopDuration - beat * 4)
                }
            }
    }
}

/// Emoji que sobe 18 pt e inclina 8° a mais, e volta. Começa depois de `delay` para formar a onda.
private struct FloatingEmoji: View {
    let emoji: String
    let angle: Double
    let delay: Double

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private static let rise = 0.8

    var body: some View {
        Text(emoji)
            .keyframeAnimator(initialValue: Pose(), repeating: !reduceMotion) { content, pose in
                content
                    .rotationEffect(.degrees(angle + pose.tilt))
                    .offset(y: pose.y)
            } keyframes: { _ in
                let rest = EmojiMysteryScene.loopDuration - delay - Self.rise * 2
                KeyframeTrack(\.y) {
                    LinearKeyframe(0, duration: delay)
                    CubicKeyframe(-18, duration: Self.rise)
                    CubicKeyframe(0, duration: Self.rise)
                    LinearKeyframe(0, duration: rest)
                }
                KeyframeTrack(\.tilt) {
                    LinearKeyframe(0, duration: delay)
                    CubicKeyframe(8, duration: Self.rise)
                    CubicKeyframe(0, duration: Self.rise)
                    LinearKeyframe(0, duration: rest)
                }
            }
    }

    private struct Pose {
        var y: CGFloat = 0
        var tilt: Double = 0
    }
}

#Preview {
    HStack(spacing: 0) {
        EmojiMysteryScene(stage: .calculating).background(.plum)
        EmojiMysteryScene(stage: .almostThere).background(.plum)
    }
    .ignoresSafeArea()
}

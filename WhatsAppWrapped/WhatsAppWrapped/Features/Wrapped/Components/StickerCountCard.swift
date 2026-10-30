//
//  StickerCountCard.swift
//  WhatsAppWrapped
//
//  Slide 17e: o total de figurinhas num "adesivo" creme recortado, inclinado 4°, com sombra.
//  Entra como uma figurinha sendo colada: de 1,5× e 18° para 0,96 e depois 1, já na inclinação final.
//

import SwiftUI

struct StickerCountCard: View {
    let count: Int
    var caption = "figurinhas enviadas"

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(count, format: .number)
                .textStyle(.numberSticker, minimumScale: 0.5)
            Text(caption)
                .textStyle(TextStyle(size: 18, weight: .bold, lineHeight: 26, relativeTo: .headline))
        }
        .foregroundStyle(.ink)
        // 32×28 de respiro + a borda creme de 8 do "recorte".
        .padding(.horizontal, 40)
        .padding(.vertical, 36)
        .background(.cream, in: .rect(cornerRadius: 40))
        .shadow(color: .ink.opacity(0.22), radius: 10, y: 10)
        .keyframeAnimator(initialValue: reduceMotion ? Pose.stuck : Pose.start, repeating: false) { content, pose in
            content
                .scaleEffect(pose.scale)
                .rotationEffect(.degrees(pose.angle))
                .opacity(pose.opacity)
        } keyframes: { _ in
            // Com "Reduzir movimento", todas as faixas já começam no adesivo colado.
            let from = reduceMotion ? Pose.stuck : Pose.start
            KeyframeTrack(\.opacity) {
                LinearKeyframe(from.opacity, duration: 0.2)
                CubicKeyframe(1, duration: 0.15)
            }
            KeyframeTrack(\.scale) {
                LinearKeyframe(from.scale, duration: 0.2)
                CubicKeyframe(0.96, duration: 0.35)
                CubicKeyframe(1, duration: 0.2)
            }
            KeyframeTrack(\.angle) {
                LinearKeyframe(from.angle, duration: 0.2)
                CubicKeyframe(Pose.stuck.angle, duration: 0.4)
            }
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
    }

    private struct Pose {
        var scale: CGFloat
        var angle: Double
        var opacity: Double

        static let start = Pose(scale: 1.5, angle: 18, opacity: 0)
        static let stuck = Pose(scale: 1, angle: 4, opacity: 1)
    }
}

#Preview {
    StickerCountCard(count: 341)
        .padding(32)
        .background(.lime)
}

//
//  IncomingCall.swift
//  WhatsAppWrapped
//
//  Slide 17b: tela de "chamando…" que abre as ligações. Foto de 128 batendo (1 → 1,05, duas vezes),
//  três anéis lima e rosa se espalhando a partir dela (até 2,2×, defasados) e os botões Recusar / Atender,
//  com o telefone balançando. Loop de 2,5 s.
//

import SwiftUI

struct IncomingCallCaller: View {
    let name: String
    /// "chamando…", "chamada de vídeo em grupo…".
    let status: String
    var isGroup = false

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        VStack(spacing: 12) {
            AvatarView(name: name, size: .call, maxInitials: isGroup ? 2 : 1)
                .keyframeAnimator(initialValue: 1.0, repeating: !reduceMotion) { content, scale in
                    content.scaleEffect(scale)
                } keyframes: { _ in
                    KeyframeTrack {
                        CubicKeyframe(1.05, duration: IncomingCallRings.loopDuration * 0.1)
                        CubicKeyframe(1, duration: IncomingCallRings.loopDuration * 0.1)
                        CubicKeyframe(1.05, duration: IncomingCallRings.loopDuration * 0.1)
                        CubicKeyframe(1, duration: IncomingCallRings.loopDuration * 0.1)
                        LinearKeyframe(1, duration: IncomingCallRings.loopDuration * 0.6)
                    }
                }
                .background { IncomingCallRings() }
            Text(name)
                .textStyle(.heading2)
                .multilineTextAlignment(.center)
            Text(status)
                .textStyle(.bodyL)
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
    }
}

/// Anéis de 128 pt saindo da foto, um a cada 0,5 s.
struct IncomingCallRings: View {
    static let loopDuration = 2.5

    /// Do Figma: anel e momento em que começa a crescer (cada um leva `spread` segundos).
    private static let rings: [(image: ImageResource, start: Double)] = [
        (.decoRingLime128, 0),
        (.decoRingRose128, 0.5),
        (.decoRingLime128, 1),
    ]

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        if !reduceMotion {
            ZStack {
                ForEach(Self.rings.indices, id: \.self) { index in
                    PulsingRing(image: Self.rings[index].image, start: Self.rings[index].start)
                }
            }
            .frame(width: 128, height: 128)
            .accessibilityHidden(true)
        }
    }
}

private struct PulsingRing: View {
    let image: ImageResource
    let start: Double

    private static let spread = 1.5

    var body: some View {
        Image(image)
            .resizable()
            .keyframeAnimator(initialValue: Pose(), repeating: true) { content, pose in
                content.scaleEffect(pose.scale).opacity(pose.opacity)
            } keyframes: { _ in
                let rest = IncomingCallRings.loopDuration - start - Self.spread
                KeyframeTrack(\.scale) {
                    LinearKeyframe(1, duration: start)
                    CubicKeyframe(2.2, duration: Self.spread)
                    LinearKeyframe(2.2, duration: rest)
                }
                KeyframeTrack(\.opacity) {
                    LinearKeyframe(0.9, duration: start)
                    CubicKeyframe(0, duration: Self.spread)
                    LinearKeyframe(0, duration: rest)
                }
            }
    }

    private struct Pose {
        var scale: CGFloat = 1
        var opacity = 0.9
    }
}

/// Recusar (coral escuro, ✕) e Atender (lima, 📞 balançando), separados nas pontas.
struct IncomingCallActions: View {
    let decline: () -> Void
    let accept: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        HStack(alignment: .top) {
            CallActionButton(title: "Recusar", fill: .coralDeep, action: decline) {
                Image(systemName: "xmark")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.cream)
            }
            Spacer()
            CallActionButton(title: "Atender", fill: .lime, action: accept) {
                Text("📞")
                    .textStyle(.title)
                    .keyframeAnimator(initialValue: 0.0, repeating: !reduceMotion) { content, angle in
                        content.rotationEffect(.degrees(angle))
                    } keyframes: { _ in
                        let step = IncomingCallRings.loopDuration * 0.04
                        KeyframeTrack {
                            CubicKeyframe(12, duration: step)
                            CubicKeyframe(-12, duration: step)
                            CubicKeyframe(12, duration: step)
                            CubicKeyframe(0, duration: step)
                            LinearKeyframe(0, duration: IncomingCallRings.loopDuration - step * 4)
                        }
                    }
            }
        }
        .padding(.horizontal, 40)
    }
}

private struct CallActionButton<Icon: View>: View {
    let title: String
    let fill: Color
    let action: () -> Void
    @ViewBuilder let icon: Icon

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                icon
                    .frame(width: 72, height: 72)
                    .background(fill, in: .circle)
                Text(title)
                    .textStyle(.bodyS)
            }
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ScreenContainer(backdrop: .plum) {
        Spacer()
        IncomingCallCaller(name: "Nicole", status: "chamando…")
        Spacer()
        IncomingCallActions(decline: {}, accept: {})
    }
}

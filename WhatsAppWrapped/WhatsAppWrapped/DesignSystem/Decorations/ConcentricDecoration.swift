//
//  ConcentricDecoration.swift
//  WhatsAppWrapped
//
//  Formas concêntricas (arcos cheios ou anéis) a partir de um centro do frame do Figma.
//  Animações: subir da base e respirar (onboarding, pronto), crescer em cascata (emoji #1) ou parado (anéis).
//

import SwiftUI

struct ConcentricDecoration: View {
    struct Layer {
        let image: ImageResource
        let diameter: CGFloat
    }

    enum Animation {
        case none
        /// Sobe 260 pt, um arco depois do outro, e depois "respira" (escala 1→1,04).
        case riseAndBreathe
        /// Cresce do centro, um depois do outro (arcos atrás do emoji #1).
        case growCascade
    }

    /// Do maior para o menor: o último fica por cima.
    let layers: [Layer]
    /// Centro comum, em coordenadas do Figma.
    let center: CGPoint
    var animation: Animation = .none

    var body: some View {
        FigmaCanvas { scale in
            ForEach(layers.indices, id: \.self) { index in
                AnimatedLayer(image: layers[index].image, index: index, animation: animation)
                    .frame(width: scale.length(layers[index].diameter), height: scale.length(layers[index].diameter))
                    .position(scale.point(center))
            }
        }
    }
}

private struct AnimatedLayer: View {
    let image: ImageResource
    let index: Int
    let animation: ConcentricDecoration.Animation

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var hasEntered = false
    @State private var isBreathing = false

    /// Os arcos terminam de entrar em 0,95 s, 1,07 s, 1,19 s…
    private var entranceDuration: Double { 0.95 + Double(index) * 0.12 }

    var body: some View {
        Image(image)
            .resizable()
            .scaleEffect(scale)
            .offset(y: animation == .riseAndBreathe && !hasEntered ? 260 : 0)
            .onAppear(perform: start)
    }

    private var scale: CGFloat {
        switch animation {
        case .none: 1
        case .riseAndBreathe: isBreathing ? 1.04 : 1
        case .growCascade: hasEntered ? 1 : 0.2
        }
    }

    private func start() {
        guard animation != .none, !reduceMotion else { hasEntered = true; return }
        switch animation {
        case .none:
            break
        case .riseAndBreathe:
            withAnimation(.easeOut(duration: entranceDuration)) { hasEntered = true }
            withAnimation(.easeInOut(duration: 1.4).repeatForever().delay(entranceDuration)) { isBreathing = true }
        case .growCascade:
            withAnimation(Motion.pop.delay(Double(index) * Motion.cascadeStep)) { hasEntered = true }
        }
    }
}

extension ConcentricDecoration {
    /// Quatro semicírculos (600, 460, 320, 180) com centro 48 pt abaixo da base, subindo e respirando.
    /// `images` do maior para o menor.
    static func bottomArcs(_ images: [ImageResource]) -> ConcentricDecoration {
        ConcentricDecoration(
            layers: zip(images, [600, 460, 320, 180]).map { Layer(image: $0, diameter: $1) },
            center: CGPoint(x: 196.5, y: 900),
            animation: .riseAndBreathe
        )
    }
}

//
//  Motion.swift
//  WhatsAppWrapped
//
//  Tokens de movimento do Figma (fast, base, slow, ambient) e as animações de entrada reutilizadas nas telas.
//  Com "Reduzir movimento" ligado, as entradas viram só um fade e as decorações ficam paradas.
//

import SwiftUI

enum Motion {
    /// Toques, estados de botão.
    static let fast = 0.2
    /// Entradas de texto, transição entre telas.
    static let base = 0.4
    /// Pop do emoji, números.
    static let slow = 0.7

    /// "Ease out back" dos pops (balão da IA, emoji #1, alerta).
    static let pop = Animation.timingCurve(0.45, 1.45, 0.8, 1, duration: 0.45)
    /// Fade entre telas e entre histórias.
    static let screenTransition = Animation.easeInOut(duration: 0.3)
    /// Intervalo entre itens que entram em cascata (cards do resumo, passos).
    static let cascadeStep = 0.08
    /// Momento em que o balão da IA entra, depois do número.
    static let phraseDelay = 0.9
}

extension View {
    /// Entrada do título: opacidade 0→1 e sobe `offset` pontos, com ease out.
    func entrance(delay: Double = 0, offset: CGFloat = 16, duration: Double = Motion.base) -> some View {
        modifier(AppearAnimation(effect: .rise(offset), delay: delay, animation: .easeOut(duration: duration)))
    }

    /// Entrada com pop: escala 0,9→1 com "ease out back". Usado no balão da IA.
    func popEntrance(delay: Double = Motion.phraseDelay, from scale: CGFloat = 0.9) -> some View {
        modifier(AppearAnimation(effect: .grow(from: scale), delay: delay, animation: Motion.pop))
    }

    /// Balança para os lados, como o card de arquivo quando o arquivo é inválido. Mude `trigger` para tocar.
    func shake(trigger: some Equatable) -> some View {
        keyframeAnimator(initialValue: 0.0, trigger: trigger) { content, x in
            content.offset(x: x)
        } keyframes: { _ in
            KeyframeTrack {
                LinearKeyframe(0, duration: 0.3)
                CubicKeyframe(-10, duration: 0.08)
                CubicKeyframe(10, duration: 0.08)
                CubicKeyframe(-6, duration: 0.08)
                CubicKeyframe(6, duration: 0.08)
                CubicKeyframe(0, duration: 0.08)
            }
        }
    }
}

extension EnvironmentValues {
    /// false desliga as entradas: a view já aparece no lugar. Usado ao gerar a imagem de compartilhar,
    /// em que o `onAppear` não roda e tudo ficaria invisível.
    @Entry var showsEntrances = true
}

/// Fade de entrada + uma transformação extra. Sem a transformação com "Reduzir movimento".
private struct AppearAnimation: ViewModifier {
    enum Effect {
        case rise(CGFloat)
        case grow(from: CGFloat)
    }

    let effect: Effect
    let delay: Double
    let animation: Animation

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.showsEntrances) private var showsEntrances
    @State private var isVisible = false

    func body(content: Content) -> some View {
        let isShown = isVisible || !showsEntrances
        let isSettled = isShown || reduceMotion
        content
            .offset(y: isSettled ? 0 : riseOffset)
            .scaleEffect(isSettled ? 1 : startScale)
            .opacity(isShown ? 1 : 0)
            .onAppear {
                withAnimation(animation.delay(delay)) { isVisible = true }
            }
    }

    private var riseOffset: CGFloat {
        if case .rise(let offset) = effect { offset } else { 0 }
    }

    private var startScale: CGFloat {
        if case .grow(let scale) = effect { scale } else { 1 }
    }
}

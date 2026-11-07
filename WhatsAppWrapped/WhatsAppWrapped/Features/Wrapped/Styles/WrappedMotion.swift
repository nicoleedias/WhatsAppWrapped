//
//  WrappedMotion.swift
//  WhatsAppWrapped
//
//  Animações de entrada que só os slides usam: barras que crescem da esquerda (palavras, ligações, figurinhas)
//  e blocos que sobem da base (pódio). Com "Reduzir movimento", aparecem já no lugar.
//

import SwiftUI

extension View {
    /// Barra crescendo de 5% até a largura final, ancorada no canto `anchor`.
    func barGrowth(delay: Double = 0.5, anchor: UnitPoint = .leading) -> some View {
        modifier(GrowAnimation(axis: .horizontal, anchor: anchor, delay: delay))
    }

    /// Bloco crescendo de baixo para cima (colunas do pódio).
    func columnGrowth(delay: Double = 0.2) -> some View {
        modifier(GrowAnimation(axis: .vertical, anchor: .bottom, delay: delay))
    }
}

private struct GrowAnimation: ViewModifier {
    let axis: Axis
    let anchor: UnitPoint
    let delay: Double

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var hasGrown = false

    func body(content: Content) -> some View {
        let scale = hasGrown || reduceMotion ? 1 : 0.05
        content
            .scaleEffect(x: axis == .horizontal ? scale : 1, y: axis == .vertical ? scale : 1, anchor: anchor)
            .onAppear {
                withAnimation(.easeOut(duration: Motion.slow).delay(delay)) { hasGrown = true }
            }
    }
}

//
//  RebobinaButtonStyle.swift
//  WhatsAppWrapped
//
//  Botão do design system: altura 56, raio 28, largura toda. Tipos Primário, Primário no escuro, Secundário,
//  Destrutivo e Ghost; o estado desabilitado vem do `.disabled()` do SwiftUI (opacidade 40%).
//

import SwiftUI

struct RebobinaButtonStyle: ButtonStyle {
    enum Kind {
        /// Ação principal em fundos claros.
        case primary
        /// Ação principal em fundos escuros ("Começar").
        case primaryOnDark
        /// Ação alternativa, com contorno na cor do texto do fundo ("Ver de novo" no resumo, sobre ameixa).
        case secondary
        /// Apagar ou sair. Sempre com confirmação.
        case destructive
        /// Ação terciária, só texto ("Ver de novo").
        case ghost
    }

    let kind: Kind
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.backdrop) private var backdrop

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .textStyle(.button)
            .foregroundStyle(foreground)
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity, minHeight: 56)
            .background(background, in: .capsule)
            .overlay {
                if kind == .secondary { Capsule().strokeBorder(backdrop.foreground, lineWidth: 1.5) }
            }
            .contentShape(.capsule)
            .opacity(isEnabled ? 1 : 0.4)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeOut(duration: Motion.fast), value: configuration.isPressed)
    }

    private var foreground: Color {
        switch kind {
        case .primary, .destructive: .cream
        case .primaryOnDark: .ink
        case .secondary, .ghost: backdrop.foreground
        }
    }

    private var background: Color {
        switch kind {
        case .primary: .ink
        case .primaryOnDark: .cream
        case .destructive: .coralDeep
        case .secondary, .ghost: .clear
        }
    }
}

extension ButtonStyle where Self == RebobinaButtonStyle {
    static func rebobina(_ kind: RebobinaButtonStyle.Kind = .primary) -> RebobinaButtonStyle {
        RebobinaButtonStyle(kind: kind)
    }
}

#Preview {
    VStack(spacing: 16) {
        Button("Próximo") {}.buttonStyle(.rebobina(.primary))
        Button("Próximo") {}.buttonStyle(.rebobina(.primary)).disabled(true)
        Button("Próximo") {}.buttonStyle(.rebobina(.primaryOnDark))
        Button("Próximo") {}.buttonStyle(.rebobina(.secondary))
        Button("Próximo") {}.buttonStyle(.rebobina(.destructive))
        Button("Próximo") {}.buttonStyle(.rebobina(.ghost))
    }
    .padding(32)
    .background(.butter)
}

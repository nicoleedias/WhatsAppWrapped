//
//  ShareButton.swift
//  WhatsAppWrapped
//
//  "Compartilhar": pill de contorno no topo de cada história. A cor segue o tom do fundo da tela.
//

import SwiftUI

struct ShareButton: View {
    let action: () -> Void
    @Environment(\.backdrop) private var backdrop

    var body: some View {
        Button("Compartilhar", action: action)
            // Como no Figma: 12 SemiBold, sem caixa alta (o `.label` deixaria "COMPARTILHAR").
            .textStyle(TextStyle(size: 12, weight: .semibold, relativeTo: .caption))
            .foregroundStyle(backdrop.foreground)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .overlay { Capsule().strokeBorder(backdrop.foreground, lineWidth: 1.5) }
            .contentShape(.capsule)
    }
}

#Preview {
    HStack {
        ShareButton {}.padding().background(.coral).environment(\.backdrop, .coral)
        ShareButton {}.padding().background(.plum).environment(\.backdrop, .plum)
    }
}

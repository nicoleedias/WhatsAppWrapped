//
//  CloseButton.swift
//  WhatsAppWrapped
//
//  "Fechar" (X) no topo das histórias revistas pela lista. Círculo de contorno do mesmo tamanho do
//  "Compartilhar", na cor do fundo da tela, com área de toque de 44 pt.
//

import SwiftUI

struct CloseButton: View {
    let action: () -> Void
    @Environment(\.backdrop) private var backdrop

    var body: some View {
        Button(action: action) {
            Image(systemName: "xmark")
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(backdrop.foreground)
                .frame(width: 33, height: 33)
                .overlay { Circle().strokeBorder(backdrop.foreground, lineWidth: 1.5) }
                .frame(width: 44, height: 44)
                .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Fechar")
    }
}

#Preview {
    HStack {
        CloseButton {}.padding().background(.coral).environment(\.backdrop, .coral)
        CloseButton {}.padding().background(.plum).environment(\.backdrop, .plum)
    }
}

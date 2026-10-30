//
//  StoryHeader.swift
//  WhatsAppWrapped
//
//  Cabeçalho das histórias: barra de progresso em segmentos de 3 pt + rótulo + "Compartilhar".
//  Sem `onShare`, o botão some (ex.: slides de "calculando" e quiz). As cores seguem o fundo da tela.
//

import SwiftUI

struct StoryHeader: View {
    let label: String
    /// Índice da história atual (a partir de 0).
    let currentIndex: Int
    var segmentCount = 12
    var onShare: (() -> Void)?

    var body: some View {
        VStack(spacing: 24) {
            StoryProgressBar(currentIndex: currentIndex, segmentCount: segmentCount)
            HStack {
                Text(label).textStyle(.label)
                Spacer()
                if let onShare { ShareButton(action: onShare) }
            }
            .frame(minHeight: 35)
        }
    }
}

/// Segmentos já vistos ficam cheios; os próximos, apagados.
struct StoryProgressBar: View {
    let currentIndex: Int
    let segmentCount: Int
    @Environment(\.backdrop) private var backdrop

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<segmentCount, id: \.self) { index in
                RoundedRectangle(cornerRadius: 2)
                    .fill(backdrop.foreground.opacity(index <= currentIndex ? 1 : 0.3))
                    .frame(height: 3)
            }
        }
        .animation(.easeOut(duration: Motion.base), value: currentIndex)
        .accessibilityElement()
        .accessibilityLabel("História \(currentIndex + 1) de \(segmentCount)")
    }
}

#Preview {
    VStack(spacing: 32) {
        StoryHeader(label: "Mensagens", currentIndex: 3, onShare: {})
            .padding().background(.coral).environment(\.backdrop, .coral)
        StoryHeader(label: "Emoji", currentIndex: 5)
            .padding().background(.plum).environment(\.backdrop, .plum)
    }
}

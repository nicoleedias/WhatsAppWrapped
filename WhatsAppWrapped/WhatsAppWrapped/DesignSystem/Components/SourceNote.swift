//
//  SourceNote.swift
//  WhatsAppWrapped
//
//  "Fonte dos dados": etiqueta pequena na cor do fundo, fixa no rodapé. Fica legível mesmo sobre as decorações.
//

import SwiftUI

struct SourceNote: View {
    var text = "Feito com a conversa que você exportou do WhatsApp"
    @Environment(\.backdrop) private var backdrop

    var body: some View {
        Text(text)
            .textStyle(.caption)
            .multilineTextAlignment(.center)
            .foregroundStyle(backdrop.foreground)
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .background(backdrop.color, in: .rect(cornerRadius: 12))
    }
}

extension View {
    /// Fixa a `SourceNote` a `bottomInset` pontos da base da tela.
    func sourceNote(_ text: String? = nil, bottomInset: CGFloat = 16) -> some View {
        overlay(alignment: .bottom) {
            Group {
                if let text { SourceNote(text: text) } else { SourceNote() }
            }
            .padding(.bottom, bottomInset)
        }
    }
}

#Preview {
    VStack {
        SourceNote().padding().background(.coral).environment(\.backdrop, .coral)
        SourceNote().padding().background(.plum).environment(\.backdrop, .plum)
    }
}

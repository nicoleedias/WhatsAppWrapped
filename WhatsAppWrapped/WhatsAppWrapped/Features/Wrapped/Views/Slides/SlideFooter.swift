//
//  SlideFooter.swift
//  WhatsAppWrapped
//
//  O rodapé de todo slide: "Você & Gabriel" (ou o nome do grupo), para um slide compartilhado sozinho
//  dizer de que conversa é. Na imagem de compartilhar, ganha embaixo a nota "Feito com a conversa…".
//

import SwiftUI

struct SlideFooter: View {
    @Environment(\.slideContext) private var context

    var body: some View {
        let lines = [context.chatName, context.isPoster ? SourceNote.exportNote : ""].filter { !$0.isEmpty }
        if !lines.isEmpty {
            SourceNote(text: lines.joined(separator: "\n"))
        }
    }
}

extension View {
    /// Fixa o `SlideFooter` a `bottomInset` pontos da base da tela.
    func slideFooter(bottomInset: CGFloat = 16) -> some View {
        overlay(alignment: .bottom) {
            SlideFooter().padding(.bottom, bottomInset)
        }
    }
}

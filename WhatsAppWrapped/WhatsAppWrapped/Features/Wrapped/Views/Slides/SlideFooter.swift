//
//  SlideFooter.swift
//  WhatsAppWrapped
//
//  O rodapé de todo slide: "Você & Gabriel" (ou o nome do grupo), para um slide compartilhado sozinho
//  dizer de que conversa é. Na imagem do story, vira o `StoryFooter`: nome, nota de fonte e marca do app.
//

import SwiftUI

struct SlideFooter: View {
    @Environment(\.slideContext) private var context

    var bottomInset: CGFloat = 16

    var body: some View {
        if context.isPoster {
            StoryFooter(chatName: context.chatName.isEmpty ? nil : context.chatName)
        } else if !context.chatName.isEmpty {
            SourceNote(text: context.chatName)
                .padding(.bottom, bottomInset)
        }
    }
}

extension View {
    /// Fixa o `SlideFooter` a `bottomInset` pontos da base da tela.
    func slideFooter(bottomInset: CGFloat = 16) -> some View {
        overlay(alignment: .bottom) {
            SlideFooter(bottomInset: bottomInset)
        }
    }
}

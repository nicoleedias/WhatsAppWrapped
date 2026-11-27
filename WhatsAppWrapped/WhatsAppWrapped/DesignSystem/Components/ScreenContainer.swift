//
//  ScreenContainer.swift
//  WhatsAppWrapped
//
//  Base de todas as telas: fundo chapado de ponta a ponta, decoração atrás, conteúdo com as margens do grid
//  (laterais 32, topo 24 abaixo da área segura, base 48 da borda) e um rodapé opcional fixo na base.
//  O topo conta a partir da área segura para o conteúdo não encostar na Dynamic Island em nenhum iPhone.
//  Na imagem do story (`isStoryPoster`), as margens são as do quadro 9:16 do `StoryPoster`.
//

import SwiftUI

struct ScreenContainer<Content: View, Decoration: View, Footer: View>: View {
    let backdrop: Backdrop
    var bottomPadding: CGFloat = 48
    @ViewBuilder let decoration: Decoration
    @ViewBuilder let content: Content
    @ViewBuilder let footer: Footer

    @Environment(\.isStoryPoster) private var isStoryPoster

    var body: some View {
        VStack(alignment: .leading, spacing: isStoryPoster ? StoryPoster.blockSpacing : 24) {
            content
        }
        .padding(.horizontal, isStoryPoster ? StoryPoster.horizontalPadding : 32)
        .padding(.top, isStoryPoster ? StoryPoster.topPadding : 24)
        .padding(.bottom, isStoryPoster ? StoryPoster.bottomPadding : bottomPadding)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background {
            ZStack {
                backdrop.color
                decoration
            }
            .clipped()
            .ignoresSafeArea()
        }
        .overlay(alignment: .bottom) {
            footer
        }
        .foregroundStyle(backdrop.foreground)
        .environment(\.backdrop, backdrop)
        .ignoresSafeArea(edges: isStoryPoster ? .all : .bottom)
    }
}

extension ScreenContainer where Footer == EmptyView {
    init(
        backdrop: Backdrop,
        bottomPadding: CGFloat = 48,
        @ViewBuilder decoration: () -> Decoration,
        @ViewBuilder content: () -> Content
    ) {
        self.init(backdrop: backdrop, bottomPadding: bottomPadding, decoration: decoration, content: content, footer: { EmptyView() })
    }
}

extension ScreenContainer where Decoration == EmptyView, Footer == EmptyView {
    init(backdrop: Backdrop, bottomPadding: CGFloat = 48, @ViewBuilder content: () -> Content) {
        self.init(backdrop: backdrop, bottomPadding: bottomPadding, decoration: { EmptyView() }, content: content, footer: { EmptyView() })
    }
}

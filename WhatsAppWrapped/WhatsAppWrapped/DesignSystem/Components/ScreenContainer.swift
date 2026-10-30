//
//  ScreenContainer.swift
//  WhatsAppWrapped
//
//  Base de todas as telas: fundo chapado de ponta a ponta, decoração atrás, conteúdo com as margens do grid
//  (laterais 32, topo 64, base 48) e um rodapé opcional fixo na base, como nos frames de 393×852 do Figma.
//

import SwiftUI

struct ScreenContainer<Content: View, Decoration: View, Footer: View>: View {
    let backdrop: Backdrop
    var bottomPadding: CGFloat = 48
    @ViewBuilder let decoration: Decoration
    @ViewBuilder let content: Content
    @ViewBuilder let footer: Footer

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            content
        }
        .padding(.horizontal, 32)
        .padding(.top, 64)
        .padding(.bottom, bottomPadding)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background {
            ZStack {
                backdrop.color
                decoration
            }
            .clipped()
        }
        .overlay(alignment: .bottom) {
            footer
        }
        .foregroundStyle(backdrop.foreground)
        .environment(\.backdrop, backdrop)
        .ignoresSafeArea()
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

//
//  SlideHeader.swift
//  WhatsAppWrapped
//
//  O topo de todo slide (progresso, rótulo e compartilhar), lido do `SlideContext`. Na imagem do story,
//  sem a barra de progresso e com a marca do app no lugar do botão de compartilhar.
//

import SwiftUI

struct SlideHeader: View {
    @Environment(\.slideContext) private var context

    var body: some View {
        if context.isPoster {
            HStack {
                Text(context.label).textStyle(.label)
                Spacer()
                BrandMark(iconSize: 24)
            }
            .frame(minHeight: 35)
        } else {
            header
        }
    }

    private var header: some View {
        StoryHeader(
            label: context.label,
            currentIndex: context.index,
            segmentCount: context.segmentCount,
            showsProgress: !context.isPoster,
            onShare: context.share
        )
    }
}

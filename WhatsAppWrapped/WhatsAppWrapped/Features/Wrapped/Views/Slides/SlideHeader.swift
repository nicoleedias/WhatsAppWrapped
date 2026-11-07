//
//  SlideHeader.swift
//  WhatsAppWrapped
//
//  O topo de todo slide (progresso, rótulo e compartilhar), lido do `SlideContext`. Na imagem de
//  compartilhar, sem a barra de progresso.
//

import SwiftUI

struct SlideHeader: View {
    @Environment(\.slideContext) private var context

    var body: some View {
        StoryHeader(
            label: context.label,
            currentIndex: context.index,
            segmentCount: context.segmentCount,
            showsProgress: !context.isPoster,
            onShare: context.share
        )
    }
}

//
//  SummaryView.swift
//  WhatsAppWrapped
//
//  Slide 21: o resumo final sobre ameixa, com o botão de compartilhar o card como imagem e o de ver os
//  slides de novo. A imagem é gerada uma vez, sem as animações de entrada. A nota de fonte só aparece nela.
//

import SwiftUI

struct SummaryView: View {
    let viewModel: SummaryViewModel
    var segmentCount = 12
    let replay: () -> Void

    @Environment(\.displayScale) private var displayScale
    @State private var shareImage: Image?

    var body: some View {
        ScreenContainer(backdrop: .plum) {
            BurstDecoration.summary
        } content: {
            VStack(spacing: 8) {
                StoryProgressBar(currentIndex: segmentCount - 1, segmentCount: segmentCount)
                SummaryCard(viewModel: viewModel)
            }
            Spacer(minLength: 16)
            VStack(spacing: 8) {
                shareButton
                Button("Ver de novo", action: replay)
                    .buttonStyle(.rebobina(.secondary))
            }
        }
        .task { renderShareImage() }
    }

    @ViewBuilder
    private var shareButton: some View {
        if let shareImage {
            ShareLink(
                item: shareImage,
                preview: SharePreview("Minha retrospectiva do WhatsApp", image: shareImage)
            ) {
                Text("Compartilhar")
            }
            .buttonStyle(.rebobina(.primaryOnDark))
        } else {
            Button("Compartilhar") {}
                .buttonStyle(.rebobina(.primaryOnDark))
                .disabled(true)
        }
    }

    private func renderShareImage() {
        shareImage = SummaryCard.shareImage(for: viewModel, scale: displayScale)
    }
}

#Preview("Duas pessoas") {
    SummaryView(viewModel: SummaryViewModel(result: .preview), replay: {})
}

#Preview("Grupo") {
    SummaryView(viewModel: SummaryViewModel(result: .previewGroup), replay: {})
}

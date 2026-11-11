//
//  SummaryView.swift
//  WhatsAppWrapped
//
//  Slide 21: o resumo final sobre ameixa, com os botões de compartilhar o card como imagem e de voltar
//  para "Minhas retrospectivas", como no Figma. A imagem é gerada uma vez, sem as animações de entrada.
//  A nota de fonte só aparece nela.
//

import SwiftUI

struct SummaryView: View {
    let viewModel: SummaryViewModel
    var segmentCount = 12
    /// "Minhas retrospectivas": a lista com todas as retrospectivas salvas.
    let showRetrospectives: () -> Void

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
                // No Figma, o botão de contorno tem texto de 16 pt, um degrau abaixo do principal.
                Button(action: showRetrospectives) {
                    Text("Minhas retrospectivas")
                        .textStyle(TextStyle(size: 16, weight: .semibold, relativeTo: .callout))
                }
                .buttonStyle(.rebobina(.secondary))
            }
        }
        .hapticOnAppear(.success, delay: 0.3)
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
        shareImage = SummaryCard.shareImage(for: viewModel)
    }
}

#Preview("Duas pessoas") {
    SummaryView(viewModel: SummaryViewModel(result: .preview), showRetrospectives: {})
}

#Preview("Grupo") {
    SummaryView(viewModel: SummaryViewModel(result: .previewGroup), showRetrospectives: {})
}

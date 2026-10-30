//
//  SummaryView.swift
//  WhatsAppWrapped
//
//  Slide 21: o resumo final sobre ameixa, com o botão de compartilhar o card como imagem e o de ver os
//  slides de novo. A imagem é gerada uma vez, sem as animações de entrada.
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
        .sourceNote()
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

    /// Story 9:16 com o card, a decoração e a nota de fonte, no tamanho do frame do Figma.
    private func renderShareImage() {
        let poster = ScreenContainer(backdrop: .plum) {
            BurstDecoration.summary
        } content: {
            Spacer(minLength: 0)
            SummaryCard(viewModel: viewModel)
            Spacer(minLength: 0)
        }
        .sourceNote()
        .frame(width: FigmaScale.frame.width, height: FigmaScale.frame.height)
        .environment(\.showsEntrances, false)

        let renderer = ImageRenderer(content: poster)
        renderer.scale = displayScale
        shareImage = renderer.uiImage.map { Image(uiImage: $0) }
    }
}

/// Cabeçalho, total, destaques e quem demora mais. Igual na tela e na imagem compartilhada.
private struct SummaryCard: View {
    let viewModel: SummaryViewModel

    var body: some View {
        VStack(spacing: 8) {
            SummaryHeader(participants: viewModel.participants, title: viewModel.title, subtitle: viewModel.subtitle)
            SummaryHero(messageCount: viewModel.messageCount)
            SummaryStatGrid(stats: viewModel.highlights.map(stat))
            if let slowest = viewModel.slowestResponder {
                SummaryHighlight(value: slowest)
            }
        }
    }

    private func stat(_ highlight: SummaryViewModel.Highlight) -> SummaryStatGrid.Stat {
        let tint: StatCard.Tint = switch highlight.kind {
        case .emoji: .rose
        case .laughs: .butter
        case .streak: .coral
        case .peakHour: .lilac
        }
        return .init(emoji: highlight.emoji, value: highlight.value, caption: highlight.caption, tint: tint)
    }
}

#Preview("Duas pessoas") {
    SummaryView(viewModel: SummaryViewModel(result: .preview), replay: {})
}

#Preview("Grupo") {
    SummaryView(viewModel: SummaryViewModel(result: .previewGroup), replay: {})
}

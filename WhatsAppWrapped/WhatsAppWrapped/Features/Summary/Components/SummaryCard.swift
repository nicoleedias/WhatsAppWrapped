//
//  SummaryCard.swift
//  WhatsAppWrapped
//
//  Cabeçalho, total, destaques e quem demora mais do slide 21. Aparece na tela e na imagem de
//  compartilhar, que também sai do menu de ações de "Minhas retrospectivas".
//

import SwiftUI

struct SummaryCard: View {
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

    /// Story 1080×1920 com o card, a decoração, a nota de fonte e a marca do app (ver `StoryPoster`).
    static func shareImage(for viewModel: SummaryViewModel) -> Image? {
        let image = StoryPoster.render {
            ScreenContainer(backdrop: .plum) {
                BurstDecoration.summary
            } content: {
                Spacer(minLength: 0)
                SummaryCard(viewModel: viewModel)
                Spacer(minLength: 0)
            }
            .overlay(alignment: .bottom) { StoryFooter(showsBrand: true) }
        }
        return image.map { Image(uiImage: $0) }
    }
}

#Preview {
    SummaryCard(viewModel: SummaryViewModel(result: .preview))
        .padding(32)
        .background(.plum)
        .environment(\.backdrop, .plum)
}

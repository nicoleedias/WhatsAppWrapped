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

    /// Story 9:16 com o card, a decoração e a nota de fonte, no tamanho do frame do Figma.
    /// As entradas ficam desligadas: o `ImageRenderer` não roda `onAppear` e tudo sairia invisível.
    static func shareImage(for viewModel: SummaryViewModel, scale: CGFloat) -> Image? {
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
        renderer.scale = scale
        return renderer.uiImage.map { Image(uiImage: $0) }
    }
}

#Preview {
    SummaryCard(viewModel: SummaryViewModel(result: .preview))
        .padding(32)
        .background(.plum)
        .environment(\.backdrop, .plum)
}

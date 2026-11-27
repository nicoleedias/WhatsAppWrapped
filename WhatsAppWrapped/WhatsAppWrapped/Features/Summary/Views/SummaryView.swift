//
//  SummaryView.swift
//  WhatsAppWrapped
//
//  Slide 21: o resumo final sobre ameixa, com os botões de compartilhar o card como imagem e de voltar
//  para "Minhas retrospectivas", como no Figma. Como nas histórias, um toque no terço esquerdo volta para
//  o último slide (os botões têm prioridade sobre o toque). A imagem é gerada uma vez, sem as animações de entrada.
//  A nota de fonte só aparece nela.
//

import SwiftUI

struct SummaryView: View {
    let viewModel: SummaryViewModel
    var segmentCount = 12
    /// "Minhas retrospectivas": a lista com todas as retrospectivas salvas.
    let showRetrospectives: () -> Void
    /// Toque no terço esquerdo: volta para o último slide.
    var previousSlide: (() -> Void)?
    /// "Ver o ano inteiro": só na retrospectiva grátis de 30 dias.
    var unlockFullYear: (() -> Void)?

    @State private var shareImage: Image?
    @State private var width: CGFloat = 0

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
                if let unlockFullYear {
                    Button(action: unlockFullYear) {
                        Text("Ver o ano inteiro")
                            .textStyle(TextStyle(size: 16, weight: .semibold, relativeTo: .callout))
                    }
                    .buttonStyle(.rebobina(.secondary))
                }
                // No Figma, o botão de contorno tem texto de 16 pt, um degrau abaixo do principal.
                // Sem contorno (grátis), o ícone de lista deixa claro que é um botão.
                Button(action: showRetrospectives) {
                    Label("Minhas retrospectivas", systemImage: "square.grid.2x2.fill")
                        .labelStyle(SummaryLinkLabelStyle())
                        .textStyle(TextStyle(size: 16, weight: .semibold, relativeTo: .callout))
                }
                .buttonStyle(.rebobina(unlockFullYear == nil ? .secondary : .ghost))
            }
        }
        .contentShape(.rect)
        .onTapGesture { location in
            if location.x < width / 3 { previousSlide?() }
        }
        .onGeometryChange(for: CGFloat.self) { $0.size.width } action: { width = $0 }
        .accessibilityAction(named: "História anterior") { previousSlide?() }
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

/// Ícone pequeno antes do texto, alinhado ao centro da linha.
private struct SummaryLinkLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 8) {
            configuration.icon
                .font(.system(size: 14, weight: .semibold))
                .accessibilityHidden(true)
            configuration.title
        }
    }
}

#Preview("Duas pessoas") {
    SummaryView(viewModel: SummaryViewModel(result: .preview), showRetrospectives: {})
}

#Preview("Grátis") {
    SummaryView(viewModel: SummaryViewModel(result: .preview), showRetrospectives: {}, unlockFullYear: {})
}

#Preview("Grupo") {
    SummaryView(viewModel: SummaryViewModel(result: .previewGroup), showRetrospectives: {})
}

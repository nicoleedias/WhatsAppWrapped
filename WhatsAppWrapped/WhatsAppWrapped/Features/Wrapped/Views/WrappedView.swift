//
//  WrappedView.swift
//  WhatsAppWrapped
//
//  Player dos slides 08–20, como histórias: toque no terço esquerdo volta, no resto avança. Botões dentro
//  do slide (quiz, ligação, compartilhar) têm prioridade sobre o toque. Depois do último, vem o resumo.
//

import SwiftUI

struct WrappedView: View {
    let viewModel: WrappedViewModel

    @Environment(\.displayScale) private var displayScale
    @State private var shareItem: ActivitySheet.Item?

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                if let slide = viewModel.currentSlide {
                    slide.view
                        .environment(\.slideContext, context(for: slide))
                        .id(slide.id)
                        .transition(.opacity)
                }
            }
            .contentShape(.rect)
            .onTapGesture { location in
                if location.x < proxy.size.width / 3 { viewModel.goBack() } else { viewModel.advance() }
            }
        }
        .ignoresSafeArea()
        .animation(Motion.screenTransition, value: viewModel.currentIndex)
        .accessibilityAction(named: "Próxima história", viewModel.advance)
        .accessibilityAction(named: "História anterior", viewModel.goBack)
        .sheet(item: $shareItem) { item in
            ActivitySheet(item: item)
                .presentationDetents([.medium, .large])
        }
    }

    /// `isPoster` monta a imagem compartilhada: sem o botão de compartilhar e sem a barra de progresso,
    /// com a nota de fonte no rodapé.
    private func context(for slide: WrappedSlide, isPoster: Bool = false) -> SlideContext {
        SlideContext(
            label: slide.label,
            index: viewModel.currentIndex,
            segmentCount: viewModel.segmentCount,
            phrase: viewModel.phrase(for: slide),
            chatName: viewModel.chatName,
            isPoster: isPoster,
            share: slide.isShareable && !isPoster ? { share(slide) } : nil,
            advance: viewModel.advance
        )
    }

    /// O slide atual como imagem 9:16, sem o botão, sem a barra de progresso e sem as animações de entrada.
    private func share(_ slide: WrappedSlide) {
        let poster = slide.view
            .environment(\.slideContext, context(for: slide, isPoster: true))
            .frame(width: FigmaScale.frame.width, height: FigmaScale.frame.height)
            .environment(\.showsEntrances, false)
        let renderer = ImageRenderer(content: poster)
        renderer.scale = displayScale
        shareItem = renderer.uiImage.map(ActivitySheet.Item.init)
    }
}

#Preview("Conversa a dois") {
    WrappedView(viewModel: WrappedViewModel(result: .preview, finish: {}))
}

#Preview("Grupo") {
    WrappedView(viewModel: WrappedViewModel(result: .previewGroup, finish: {}))
}

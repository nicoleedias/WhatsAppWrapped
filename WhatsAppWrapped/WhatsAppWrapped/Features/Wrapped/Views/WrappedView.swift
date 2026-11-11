//
//  WrappedView.swift
//  WhatsAppWrapped
//
//  Player dos slides 08–20, como histórias: toque no terço esquerdo volta, no resto avança (menos no quiz,
//  que só passa depois da resposta). Botões dentro do slide (quiz, ligação, compartilhar) têm prioridade
//  sobre o toque. Depois do último, vem o resumo.
//

import SwiftUI

struct WrappedView: View {
    let viewModel: WrappedViewModel

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
                if location.x < proxy.size.width / 3 { viewModel.goBack() } else { viewModel.skipForward() }
            }
        }
        .ignoresSafeArea()
        .animation(Motion.screenTransition, value: viewModel.currentIndex)
        // Um "clique" leve a cada história, como virar uma página.
        .sensoryFeedback(.selection, trigger: viewModel.currentIndex)
        .accessibilityAction(named: "Próxima história", viewModel.skipForward)
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

    /// O slide atual como story 1080×1920 (ver `StoryPoster`), sem o botão, sem a barra de progresso e sem as animações de entrada.
    private func share(_ slide: WrappedSlide) {
        let image = StoryPoster.render {
            slide.view.environment(\.slideContext, context(for: slide, isPoster: true))
        }
        shareItem = image.map(ActivitySheet.Item.init)
    }
}

#Preview("Conversa a dois") {
    WrappedView(viewModel: WrappedViewModel(result: .preview, finish: {}))
}

#Preview("Grupo") {
    WrappedView(viewModel: WrappedViewModel(result: .previewGroup, finish: {}))
}

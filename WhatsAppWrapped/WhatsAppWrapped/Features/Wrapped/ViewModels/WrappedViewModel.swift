//
//  WrappedViewModel.swift
//  WhatsAppWrapped
//
//  Slides 08–20: monta a lista de slides da retrospectiva e cuida da navegação entre eles (avançar,
//  voltar e terminar no resumo). Os textos de cada slide saem de `WrappedViewModel+Slides`.
//

import Foundation
import Observation

@Observable
final class WrappedViewModel {
    let slides: [WrappedSlide]
    private(set) var currentIndex = 0

    let stats: WrappedStats
    /// "Você & Gabriel" ou o nome do grupo, o mesmo título do resumo.
    let chatName: String
    private let phrases: SlidePhrases
    /// Chamado depois do último slide.
    private let finish: () -> Void

    init(result: WrappedResult, finish: @escaping () -> Void) {
        stats = result.stats
        phrases = result.phrases
        chatName = SummaryViewModel(result: result).title
        self.finish = finish
        slides = Self.makeSlides(for: result.stats)
    }

    var currentSlide: WrappedSlide? {
        slides.indices.contains(currentIndex) ? slides[currentIndex] : nil
    }

    /// A barra de progresso inclui o resumo final, que é o último segmento.
    var segmentCount: Int { slides.count + 1 }

    func phrase(for slide: WrappedSlide) -> SlidePhrase? {
        slide.phraseSlide.flatMap { phrases[$0] }
    }

    /// Toque ou VoiceOver em "próxima": não passa dos slides que pedem resposta (o quiz avança sozinho).
    func skipForward() {
        guard currentSlide?.requiresAnswer != true else { return }
        advance()
    }

    func advance() {
        if currentIndex + 1 < slides.count {
            currentIndex += 1
        } else {
            finish()
        }
    }

    func goBack() {
        guard currentIndex > 0 else { return }
        currentIndex -= 1
    }
}

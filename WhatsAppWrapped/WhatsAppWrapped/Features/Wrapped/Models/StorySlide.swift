//
//  StorySlide.swift
//  WhatsAppWrapped
//
//  O contrato de um slide: a view e os dados que o player precisa dela. Para criar um slide novo basta
//  uma view que segue `StorySlide` e uma linha em `WrappedViewModel.makeSlides`; o player não muda.
//

import SwiftUI

protocol StorySlide: View {
    /// Rótulo em caixa alta no topo do slide.
    static var label: String { get }
    /// Frase da IA do slide. nil nos slides sem balão.
    static var phraseSlide: PhraseSlide? { get }
    /// Os de suspense e os interativos não dá para compartilhar como imagem.
    static var isShareable: Bool { get }
}

extension StorySlide {
    static var phraseSlide: PhraseSlide? { nil }
    static var isShareable: Bool { true }

    /// Coloca o slide num contexto de exemplo, para o #Preview.
    func slidePreview(phrase: SlidePhrase? = nil) -> some View {
        environment(\.slideContext, SlideContext(label: Self.label, index: 2, segmentCount: 18, phrase: phrase, chatName: "Você & Bia", share: {}))
    }
}

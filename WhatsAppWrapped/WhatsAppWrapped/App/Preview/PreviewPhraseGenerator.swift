//
//  PreviewPhraseGenerator.swift
//  WhatsAppWrapped
//
//  Gerador de frases dos previews: devolve as frases prontas da Core, sem chamar o Gemini
//  (o Firebase não é configurado no canvas do Xcode).
//

import Foundation

nonisolated struct PreviewPhraseGenerator: SlidePhraseGenerator {
    func phrases(for stats: WrappedStats, slides: [PhraseSlide]) async throws -> SlidePhrases {
        FallbackPhrases.phrases(for: stats, slides: slides)
    }
}

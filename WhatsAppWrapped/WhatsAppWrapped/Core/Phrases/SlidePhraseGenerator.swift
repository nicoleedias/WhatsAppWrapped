//
//  SlidePhraseGenerator.swift
//  WhatsAppWrapped
//
//  Contrato de quem gera as frases. A Core só conhece este protocolo;
//  a implementação com Gemini fica em Infrastructure/Firebase.
//

import Foundation

nonisolated protocol SlidePhraseGenerator: Sendable {
    func phrases(for stats: WrappedStats, slides: [PhraseSlide]) async throws -> SlidePhrases
}

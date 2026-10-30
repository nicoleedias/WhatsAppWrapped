//
//  SlidePhraseService.swift
//  WhatsAppWrapped
//
//  Pede as frases ao gerador (IA) e completa com as frases prontas o que faltar.
//

import Foundation
import os

nonisolated enum SlidePhraseService {
    private static let logger = Logger(subsystem: "WhatsAppWrapped", category: "Phrases")

    /// Nunca falha: sem internet ou com erro na IA, devolve só as frases prontas.
    static func phrases(for stats: WrappedStats, using generator: any SlidePhraseGenerator) async -> SlidePhrases {
        let slides = PhraseSlide.applicable(to: stats)
        let fallback = FallbackPhrases.phrases(for: stats, slides: slides)
        do {
            return try await generator.phrases(for: stats, slides: slides).filled(with: fallback)
        } catch {
            logger.error("Frases da IA indisponíveis, usando frases prontas: \(error)")
            return fallback
        }
    }
}

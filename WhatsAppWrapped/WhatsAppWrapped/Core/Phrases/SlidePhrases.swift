//
//  SlidePhrases.swift
//  WhatsAppWrapped
//
//  Quais slides têm frase, o formato da frase (emoji + texto) e a regra de completar com frases prontas.
//

import Foundation

/// Slides que têm frase divertida no rodapé. O `rawValue` é a chave no JSON da IA.
nonisolated enum PhraseSlide: String, CaseIterable, Codable, Sendable {
    case messages       // 08
    case laughs         // 09
    case emojis         // 10–11
    case words          // 13
    case responseTime   // 14
    case streak         // 15
    case hours          // 16
    case audios         // 17
    case photos         // 17d
    case stickers       // 17e
    case longMessages   // 18
    case podium         // 19, só grupo
    case ghosts         // 20, só grupo
    case calls          // ligações
    case summary        // 21

    /// Slides que aparecem nesta retrospectiva (ex.: sem ligações, não tem slide de ligações).
    static func applicable(to stats: WrappedStats) -> [PhraseSlide] {
        allCases.filter { slide in
            switch slide {
            case .laughs: stats.laughs.total > 0
            case .emojis: !stats.emojis.top.isEmpty
            case .words: !stats.words.top.isEmpty
            case .responseTime: !stats.responseTimes.isEmpty
            case .streak: stats.streak.longest > 0
            case .audios: (stats.media.audios?.total ?? 0) > 0
            case .photos: (stats.media.photos?.total ?? 0) > 0
            case .stickers: (stats.media.stickers?.total ?? 0) > 0
            case .longMessages: stats.longMessages.longest != nil
            case .podium, .ghosts: stats.isGroup
            case .calls: stats.calls.total > 0
            case .messages, .hours, .summary: true
            }
        }
    }
}

/// Frase no rodapé de um slide (ex.: "🍜 Dá pra fazer 4 miojos em cada ligação.").
nonisolated struct SlidePhrase: Codable, Sendable, Hashable {
    let emoji: String
    let text: String

    /// Cabe em duas linhas no card do rodapé.
    static let maximumLength = 90

    var isValid: Bool {
        !emoji.isEmpty && !text.isEmpty && text.count <= Self.maximumLength
    }
}

/// Uma frase por slide. Diferente a cada retrospectiva, porque é gerada pela IA.
nonisolated struct SlidePhrases: Sendable {
    private(set) var phrases: [PhraseSlide: SlidePhrase]

    init(_ phrases: [PhraseSlide: SlidePhrase] = [:]) {
        self.phrases = phrases
    }

    subscript(slide: PhraseSlide) -> SlidePhrase? {
        phrases[slide]
    }

    /// Mantém as frases válidas e usa `fallback` nos slides que faltaram.
    func filled(with fallback: SlidePhrases) -> SlidePhrases {
        fallback.phrases.reduce(into: SlidePhrases(phrases.filter { $0.value.isValid })) { result, entry in
            if result.phrases[entry.key] == nil { result.phrases[entry.key] = entry.value }
        }
    }
}

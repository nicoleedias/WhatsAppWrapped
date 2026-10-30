//
//  FallbackPhrases.swift
//  WhatsAppWrapped
//
//  Frases prontas, uma por slide, usadas quando a IA não responde ou devolve frase inválida.
//

import Foundation

/// Frases prontas para quando a IA não responde.
nonisolated enum FallbackPhrases {
    static func phrases(for stats: WrappedStats, slides: [PhraseSlide]) -> SlidePhrases {
        SlidePhrases(Dictionary(uniqueKeysWithValues: slides.map { ($0, phrase(for: $0, stats: stats)) }))
    }

    private static func phrase(for slide: PhraseSlide, stats: WrappedStats) -> SlidePhrase {
        switch slide {
        case .messages:
            SlidePhrase(emoji: "💬", text: "Dava pra encher um livro só com essa conversa.")
        case .laughs:
            SlidePhrase(emoji: "😂", text: "Rir junto é o melhor tipo de conversa.")
        case .emojis:
            SlidePhrase(emoji: stats.emojis.top.first?.emoji ?? "✨", text: "Esse emoji já é praticamente da família.")
        case .words:
            SlidePhrase(emoji: "📝", text: "Tem palavra aqui que já virou marca registrada.")
        case .responseTime:
            SlidePhrase(emoji: "⏳", text: "Cada um no seu tempo, mas sempre respondendo.")
        case .streak:
            SlidePhrase(emoji: "🔥", text: "\(stats.streak.longest) dias seguidos sem deixar a conversa esfriar.")
        case .hours:
            SlidePhrase(emoji: stats.hours.favoritePartOfDay == .lateNight ? "🌙" : "⏰", text: "O papo sempre encontra a melhor hora.")
        case .audios:
            SlidePhrase(emoji: "🎙️", text: "Quando digitar não dá conta, vai de áudio.")
        case .photos:
            SlidePhrase(emoji: "📸", text: "O rolo da câmera de vocês merece um álbum de família.")
        case .stickers:
            SlidePhrase(emoji: "🧸", text: "Tem figurinha aqui pra todo tipo de situação.")
        case .longMessages:
            SlidePhrase(emoji: "📜", text: "Tem gente aqui que escreve carta, não mensagem.")
        case .podium:
            SlidePhrase(emoji: "🏆", text: "O grupo não seria o mesmo sem esse trio.")
        case .ghosts:
            SlidePhrase(emoji: "👻", text: "Lê tudo, fala pouco. A gente sabe que você tá aí.")
        case .calls:
            callPhrase(averageMinutes: (stats.calls.averageDuration ?? 0) / 60)
        case .summary:
            SlidePhrase(emoji: "💜", text: "Um ano inteiro de conversa. Que venha o próximo!")
        }
    }

    private static func callPhrase(averageMinutes: Double) -> SlidePhrase {
        let noodles = Int(averageMinutes / 3) // um miojo leva 3 minutos
        guard noodles >= 1 else {
            return SlidePhrase(emoji: "⚡", text: "Ligação rápida: resolve tudo antes do miojo ficar pronto.")
        }
        return SlidePhrase(emoji: "🍜", text: "Dá pra fazer \(noodles) \(noodles == 1 ? "miojo" : "miojos") em cada ligação.")
    }
}

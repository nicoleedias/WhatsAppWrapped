//
//  WrappedSlide.swift
//  WhatsAppWrapped
//
//  Um slide do player, já pronto para desenhar. Cada slide é uma view `StorySlide` que diz o próprio
//  rótulo, frase e se pode ser compartilhado; o player só lê esses dados, sem conhecer os tipos.
//  Os dados de cada slide (Headline, Quiz…) ficam aqui embaixo, montados pelo `WrappedViewModel`.
//

import SwiftUI

struct WrappedSlide: Identifiable {
    let id: String
    let label: String
    let phraseSlide: PhraseSlide?
    let isShareable: Bool
    let view: AnyView

    init<Slide: StorySlide>(_ slide: Slide) {
        id = String(describing: Slide.self)
        label = Slide.label
        phraseSlide = Slide.phraseSlide
        isShareable = Slide.isShareable
        view = AnyView(slide)
    }

    /// nil quando o slide não tem dados e fica de fora.
    init?<Slide: StorySlide>(_ slide: Slide?) {
        guard let slide else { return nil }
        self.init(slide)
    }
}

// MARK: - Conteúdo

extension WrappedSlide {
    /// "Vocês trocaram / 30.597 / mensagens".
    struct Headline {
        var intro: String?
        let value: String
        let caption: String
    }

    struct EmojiChampion {
        let emoji: String
        let count: Int
        /// "1.365 vezes".
        let countText: String
    }

    struct Quiz {
        let question: String
        /// Em ordem alfabética, para a resposta não ficar sempre em primeiro.
        let options: [String]
        let answer: String
    }

    struct ResponseDuel {
        let title: String
        let fastest: ResponseTimeDuel.Entry
        let slowest: ResponseTimeDuel.Entry
        /// "Nicole está digitando…", enquanto o tempo não aparece.
        let typingCaption: String
    }

    struct Hours {
        let partOfDay: HourStats.PartOfDay
        let headline: Headline
    }

    struct Audios {
        let headline: Headline
        /// Os dois que mais mandaram áudio. nil com uma pessoa só.
        let comparison: (first: AudioComparison.Entry, second: AudioComparison.Entry)?
    }

    struct IncomingCall {
        /// Quem mais ligou.
        let name: String
        let isGroup: Bool
    }

    struct Calls {
        /// "Vocês se ligaram 128 vezes".
        let title: String
        let voice: Int
        let video: Int
        let voicePercentage: Int
        let videoPercentage: Int
        /// "14:07". nil quando o arquivo não traz a duração.
        let average: String?
        /// "minutos por chamada · a maior durou 3h12".
        let averageDetail: String
    }

    struct Photos {
        let headline: Headline
        /// Os meses com mais fotos.
        let polaroids: [PolaroidStack.Item]
        /// "25 de dezembro: 64 fotos num dia só".
        let busiestDay: String?
    }

    struct Stickers {
        let count: Int
        /// "1 figurinha a cada 90 mensagens".
        let frequency: String?
        /// Quem mandou mais, numa conversa a dois.
        let split: (leading: SplitBar.Side, trailing: SplitBar.Side)?
    }

    struct LongMessage {
        /// O começo do textão. nil nas retrospectivas salvas, que não guardam texto de mensagem.
        let text: String?
        /// "Nicole · 1.284 caracteres · 14 de março, 02:13".
        let detail: String
    }
}

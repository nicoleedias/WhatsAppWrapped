//
//  WrappedTypography.swift
//  WhatsAppWrapped
//
//  Tamanhos de texto que só aparecem nos slides (fora da escala da identidade visual), tirados dos frames 08–21.
//  Seguem o Dynamic Type como os tokens do design system.
//

import SwiftUI

extension TextStyle {
    /// 29/32 · SemiBold. "Você possui", "Você riu", "Você mandou".
    static let slideIntro = TextStyle(size: 29, weight: .semibold, lineHeight: 32, tracking: -0.29, relativeTo: .title)
    /// 35/39 · SemiBold. "Você é do time da madrugada".
    static let slideIntroLarge = TextStyle(size: 35, weight: .semibold, lineHeight: 39, tracking: -0.35, relativeTo: .largeTitle)
    /// 45/50 · Bold. Títulos dos slides ("Quem demora mais pra responder?", "Calculando…").
    static let slideTitle = TextStyle(size: 45, weight: .bold, lineHeight: 50, tracking: -0.45, relativeTo: .largeTitle)
    /// 26/29 · SemiBold. Legendas grandes ("dias seguidos trocando mensagem").
    static let slideSubtitle = TextStyle(size: 26, weight: .semibold, lineHeight: 29, tracking: -0.26, relativeTo: .title)
    /// 19/21 · SemiBold. "Nicole está digitando…".
    static let slideCaption = TextStyle(size: 19, weight: .semibold, lineHeight: 21, tracking: -0.19, relativeTo: .headline)

    /// 160/179 · Bold. Sequência (15).
    static let numberGiant = TextStyle(size: 160, weight: .bold, lineHeight: 179, tracking: -1.6, relativeTo: .largeTitle)
    /// 104/109 · ExtraBold. Figurinha (17e).
    static let numberSticker = TextStyle(size: 104, weight: .extraBold, lineHeight: 109, tracking: -1.04, relativeTo: .largeTitle)
    /// 88/97 · ExtraBold. Fotos (17d).
    static let numberPhotos = TextStyle(size: 88, weight: .extraBold, lineHeight: 97, tracking: -0.88, relativeTo: .largeTitle)
    /// 80/88 · ExtraBold. Duração média da ligação (17c).
    static let numberTimer = TextStyle(size: 80, weight: .extraBold, lineHeight: 88, tracking: -0.8, relativeTo: .largeTitle)
    /// 70/78 · Bold. Tempos de resposta (14) e "Adivinha!"/"Quase!" (12).
    static let numberLarge = TextStyle(size: 70, weight: .bold, lineHeight: 78, tracking: -0.7, relativeTo: .largeTitle)
    /// 58/65 · Bold. "1.365 vezes" (11).
    static let numberMedium = TextStyle(size: 58, weight: .bold, lineHeight: 65, tracking: -0.58, relativeTo: .largeTitle)
    /// 56/64 · ExtraBold. Total de mensagens no resumo (21).
    static let numberSummary = TextStyle(size: 56, weight: .extraBold, lineHeight: 64, relativeTo: .largeTitle)
    /// 44/48 · ExtraBold. Cards de voz e vídeo (17c).
    static let numberCard = TextStyle(size: 44, weight: .extraBold, lineHeight: 48, relativeTo: .largeTitle)

    /// 26/29 · Bold. Nomes no pódio (19).
    static let podiumName = TextStyle(size: 26, weight: .bold, lineHeight: 29, tracking: -0.26, relativeTo: .title)
    /// 20 · ExtraBold. Posição no ranking, "143 dias", "Nicole · 3h42min".
    static let rankValue = TextStyle(size: 20, weight: .extraBold, relativeTo: .title3)
    /// 16 · SemiBold. "mensagens trocadas" no resumo.
    static let bodyMSemiBold = TextStyle(size: 16, weight: .semibold, relativeTo: .callout)
    /// 14 · SemiBold. Legendas dos cards do resumo e subtítulo do cabeçalho.
    static let bodySSemiBold = TextStyle(size: 14, weight: .semibold, relativeTo: .subheadline)
    /// 12 · SemiBold. Contagem embaixo do nome no pódio.
    static let captionSemiBold = TextStyle(size: 12, weight: .semibold, relativeTo: .caption)
}

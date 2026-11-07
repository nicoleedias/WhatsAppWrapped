//
//  SlideContext.swift
//  WhatsAppWrapped
//
//  O que todo slide recebe do player pelo environment: rótulo, posição na barra de progresso, frase da IA,
//  nome da conversa, compartilhar e avançar (usado pelos slides que andam sozinhos ou por toque num botão,
//  como o quiz). `isPoster` marca a imagem de compartilhar, que tira a barra de progresso e ganha a nota de fonte.
//

import SwiftUI

struct SlideContext {
    var label = ""
    var index = 0
    var segmentCount = 1
    var phrase: SlidePhrase?
    /// "Você & Gabriel" ou o nome do grupo, no rodapé de todo slide.
    var chatName = ""
    var isPoster = false
    /// nil esconde o botão "Compartilhar" (slides interativos e a imagem compartilhada).
    var share: (() -> Void)?
    var advance: () -> Void = {}
}

extension EnvironmentValues {
    @Entry var slideContext = SlideContext()
}

//
//  Message.swift
//  WhatsAppWrapped
//
//  Uma mensagem, uma ligação ou um aviso do sistema, já lidos do arquivo.
//

import Foundation

/// Uma mensagem enviada por alguém na conversa.
nonisolated struct Message: Hashable, Sendable {
    /// Data e hora como aparecem no arquivo (horário local, guardado em UTC; ver `ChatCalendar`).
    let date: Date
    let author: String
    /// Texto sem caracteres invisíveis e sem o marcador de mensagem editada.
    let text: String
    let kind: Kind

    nonisolated enum Kind: Hashable, Sendable {
        case text
        case media(MediaType)
        case deleted
    }

    var isText: Bool { kind == .text }
}

nonisolated enum MediaType: String, Hashable, Sendable, Codable, CaseIterable {
    case audio, image, video, sticker, gif, document, contact, location
    /// Android exporta toda mídia como "<Mídia oculta>", sem dizer o tipo.
    case unknown
}

/// Chamada de voz ou vídeo registrada no arquivo. Não conta como mensagem.
nonisolated struct Call: Hashable, Sendable {
    let date: Date
    /// Quem fez a ligação.
    let caller: String
    let isVideo: Bool
    /// Só chamadas atendidas têm duração. O WhatsApp arredonda para minutos a partir de 1 minuto.
    let duration: TimeInterval?
    /// Perdida, não atendida ou que falhou.
    let isMissed: Bool
}

/// Evento que não foi escrito por ninguém: aviso de criptografia, "Ana adicionou Bia" etc.
nonisolated struct SystemEvent: Hashable, Sendable {
    let date: Date
    let text: String
}

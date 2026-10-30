//
//  Chat.swift
//  WhatsAppWrapped
//
//  A conversa inteira depois do parsing: mensagens, ligações, avisos, quem entrou/saiu e quem exportou.
//

import Foundation

/// Conversa exportada do WhatsApp, já separada em mensagens.
nonisolated struct Chat: Sendable {
    /// Em ordem cronológica.
    let messages: [Message]
    let systemEvents: [SystemEvent]
    let calls: [Call]
    /// Entradas e saídas de participantes encontradas nas mensagens do sistema.
    let membershipChanges: [MembershipChange]
    let isGroup: Bool
    /// Quem exportou: o autor de "Você apagou esta mensagem" / "You deleted this message".
    let exporter: String?

    var authors: [String] {
        var seen = Set<String>()
        return messages.compactMap { seen.insert($0.author).inserted ? $0.author : nil }
    }
}

nonisolated struct MembershipChange: Hashable, Sendable {
    let date: Date
    let name: String
    let joined: Bool
}

//
//  ExportStep.swift
//  WhatsAppWrapped
//
//  Passos da tela 02 para exportar a conversa no WhatsApp e mandar direto para o app.
//

import Foundation

struct ExportStep: Identifiable {
    let number: Int
    let title: String
    let detail: String

    var id: Int { number }

    static let all = [
        ExportStep(number: 1, title: "Abra o chat", detail: "Toque no nome do contato ou grupo."),
        ExportStep(number: 2, title: "Exportar conversa", detail: "Role até o final e toque em exportar."),
        ExportStep(number: 3, title: "Sem mídia", detail: "Deixa o processo bem mais rápido."),
        ExportStep(number: 4, title: "Escolha Rebobina na lista", detail: "Na tela de compartilhar, toque no app. Pronto!"),
    ]
}

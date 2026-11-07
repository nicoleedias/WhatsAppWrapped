//
//  ChatTitle.swift
//  WhatsAppWrapped
//
//  Nome da conversa, que o texto exportado não traz no cabeçalho. Vem do nome do arquivo
//  ("WhatsApp Chat - Rolê de sexta.zip") ou, num grupo, da última vez que alguém criou ou renomeou o grupo.
//

import Foundation

nonisolated enum ChatTitle {
    /// Começos do nome do arquivo que o WhatsApp gera, em minúsculas.
    private static let fileNamePrefixes = [
        "whatsapp chat - ",             // iPhone
        "whatsapp chat with ",          // Android, inglês
        "conversa do whatsapp com ",    // Android, português
        "chat de whatsapp con ",        // Android, espanhol
    ]

    /// Mensagens de sistema que trazem o nome do grupo entre aspas, em minúsculas.
    private static let renameMarkers = [
        "criou o grupo", "criou este grupo", "mudou o nome do grupo",
        "created group", "changed the group name", "changed the subject",
    ]

    /// "WhatsApp Chat - Rolê de sexta (1).zip" → "Rolê de sexta". nil se o arquivo foi renomeado.
    static func fromFileName(_ fileName: String) -> String? {
        let name = (fileName as NSString).deletingPathExtension
        guard let prefix = fileNamePrefixes.first(where: { name.lowercased().hasPrefix($0) }) else { return nil }
        // Cópias repetidas ganham " (1)", " 2" etc. no fim.
        let title = String(name.dropFirst(prefix.count))
            .replacing(/\s*\(\d+\)$/, with: "")
            .trimmingCharacters(in: .whitespaces)
        return title.isEmpty ? nil : title
    }

    /// O nome mais recente entre aspas em "criou o grupo “…”" ou "mudou o nome do grupo de “A” para “B”".
    static func fromSystemEvents(_ events: [SystemEvent]) -> String? {
        for event in events.reversed() {
            let text = event.text.lowercased()
            guard renameMarkers.contains(where: text.contains) else { continue }
            if let quoted = event.text.matches(of: /["“]([^"”]+)["”]/).last.map({ String($0.output.1) }) {
                return quoted
            }
        }
        return nil
    }
}

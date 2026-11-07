//
//  ChatImporter.swift
//  WhatsAppWrapped
//
//  Abre o arquivo recebido (.zip ou .txt), devolve o texto da conversa e apaga a cópia deixada no app.
//

import Foundation

/// Abre o arquivo que a pessoa escolheu ou compartilhou do WhatsApp: o .zip do iPhone ou o .txt do Android.
nonisolated enum ChatImporter {
    enum ImportError: LocalizedError, Equatable {
        case unreadableFile
        case noChatInArchive
        case notAWhatsAppChat

        /// Título do card de erro (tela 03b).
        var title: String {
            switch self {
            case .unreadableFile: "Não conseguimos abrir esse arquivo"
            case .noChatInArchive: "Esse .zip não tem uma conversa dentro"
            case .notAWhatsAppChat: "Esse arquivo não é uma conversa do WhatsApp"
            }
        }

        var errorDescription: String? {
            switch self {
            case .unreadableFile, .notAWhatsAppChat:
                "Exporte de novo pelo WhatsApp e envie o .zip ou .txt."
            case .noChatInArchive:
                "Exporte de novo pelo WhatsApp escolhendo \"Sem mídia\"."
            }
        }
    }

    /// Texto da conversa. Apaga a cópia que o iOS deixa no app quando o arquivo chega pelo compartilhamento.
    static func chatText(from url: URL) throws -> String {
        let accessing = url.startAccessingSecurityScopedResource()
        defer {
            if accessing { url.stopAccessingSecurityScopedResource() }
            removeIfInsideApp(url)
        }

        guard let data = try? Data(contentsOf: url) else { throw ImportError.unreadableFile }
        let text = isZip(data) ? try chatText(fromZip: data) : decode(data)
        guard let text else { throw ImportError.unreadableFile }
        return text
    }

    private static func chatText(fromZip data: Data) throws -> String? {
        guard let entries = try? ZipReader.entries(in: data) else { throw ImportError.unreadableFile }
        // iPhone: "_chat.txt". Android (quando compacta): "Conversa do WhatsApp com Ana.txt".
        let texts = entries.filter { $0.name.lowercased().hasSuffix(".txt") && !$0.name.hasPrefix("__MACOSX") }
        guard let entry = texts.first(where: { $0.name.hasSuffix("_chat.txt") }) ?? texts.first else {
            throw ImportError.noChatInArchive
        }
        guard let contents = try? ZipReader.contents(of: entry, in: data) else { throw ImportError.unreadableFile }
        return decode(contents)
    }

    private static func isZip(_ data: Data) -> Bool {
        data.starts(with: [0x50, 0x4B, 0x03, 0x04])
    }

    private static func decode(_ data: Data) -> String? {
        String(data: data, encoding: .utf8) ?? String(data: data, encoding: .isoLatin1)
    }

    /// Com o compartilhamento, o iOS copia o arquivo para Documents/Inbox. A conversa não deve ficar guardada no app.
    private static func removeIfInsideApp(_ url: URL) {
        guard let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
              url.standardizedFileURL.path.hasPrefix(documents.standardizedFileURL.path) else { return }
        try? FileManager.default.removeItem(at: url)
    }
}

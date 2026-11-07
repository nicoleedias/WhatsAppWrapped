//
//  RetrospectiveStore.swift
//  WhatsAppWrapped
//
//  Onde ficam as retrospectivas da lista "Minhas retrospectivas". A versão de verdade grava um JSON
//  em Application Support, protegido enquanto o aparelho está bloqueado.
//

import Foundation
import os

nonisolated protocol RetrospectiveStore: Sendable {
    /// Da mais nova para a mais antiga.
    func load() throws -> [SavedRetrospective]
    func save(_ retrospective: SavedRetrospective) throws
    func delete(id: SavedRetrospective.ID) throws
}

nonisolated struct FileRetrospectiveStore: RetrospectiveStore {
    private static let logger = Logger(subsystem: "WhatsAppWrapped", category: "Retrospectives")

    let fileURL: URL

    init(fileURL: URL = Self.defaultURL) {
        self.fileURL = fileURL
    }

    static var defaultURL: URL {
        URL.applicationSupportDirectory.appending(path: "retrospectives.json")
    }

    func load() throws -> [SavedRetrospective] {
        guard FileManager.default.fileExists(atPath: fileURL.path()) else { return [] }
        let data = try Data(contentsOf: fileURL)
        do {
            return try Self.decoder.decode([SavedRetrospective].self, from: data)
                .sorted { $0.createdAt > $1.createdAt }
        } catch {
            // Arquivo de uma versão antiga ou corrompido: melhor uma lista vazia que um app travado.
            Self.logger.error("Não foi possível ler as retrospectivas salvas: \(error)")
            return []
        }
    }

    func save(_ retrospective: SavedRetrospective) throws {
        try write([retrospective] + load().filter { $0.id != retrospective.id })
    }

    func delete(id: SavedRetrospective.ID) throws {
        try write(load().filter { $0.id != id })
    }

    private func write(_ retrospectives: [SavedRetrospective]) throws {
        try FileManager.default.createDirectory(at: fileURL.deletingLastPathComponent(), withIntermediateDirectories: true)
        try Self.encoder.encode(retrospectives).write(to: fileURL, options: [.atomic, .completeFileProtection])
    }

    private static let encoder = JSONEncoder()
    private static let decoder = JSONDecoder()
}

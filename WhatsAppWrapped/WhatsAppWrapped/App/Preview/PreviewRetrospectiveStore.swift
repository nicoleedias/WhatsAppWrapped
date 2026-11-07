//
//  PreviewRetrospectiveStore.swift
//  WhatsAppWrapped
//
//  Lista de retrospectivas em memória para os previews, sem tocar no disco.
//

import Foundation

nonisolated final class PreviewRetrospectiveStore: RetrospectiveStore, @unchecked Sendable {
    private var retrospectives: [SavedRetrospective]

    init(_ retrospectives: [SavedRetrospective] = [
        SavedRetrospective(result: .preview),
        SavedRetrospective(result: .previewGroup),
    ]) {
        self.retrospectives = retrospectives
    }

    func load() throws -> [SavedRetrospective] { retrospectives }

    func save(_ retrospective: SavedRetrospective) throws {
        retrospectives.insert(retrospective, at: 0)
    }

    func delete(id: SavedRetrospective.ID) throws {
        retrospectives.removeAll { $0.id == id }
    }
}

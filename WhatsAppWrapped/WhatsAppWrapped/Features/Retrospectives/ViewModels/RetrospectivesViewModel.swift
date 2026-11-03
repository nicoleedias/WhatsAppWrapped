//
//  RetrospectivesViewModel.swift
//  WhatsAppWrapped
//
//  Telas 00a–00d: a lista de retrospectivas guardadas, o menu de ações de cada uma e a confirmação
//  antes de apagar. Abrir o resumo, rever as histórias e começar uma nova ficam com o `AppViewModel`.
//

import Foundation
import Observation

@Observable
final class RetrospectivesViewModel {
    /// O que um cartão da lista mostra.
    struct Card: Identifiable, Hashable {
        let id: SavedRetrospective.ID
        let isGroup: Bool
        /// "Individual · 2026", "Grupo · 2026".
        let tag: String
        /// "Nicole", "Rolê de sexta".
        let title: String
        /// "30.597 mensagens".
        let highlight: String
        /// Fotos do cartão: a outra pessoa, ou os participantes do grupo.
        let participants: [String]
    }

    private(set) var retrospectives: [SavedRetrospective] = []
    /// Cartão com o menu de ações (00c) aberto.
    var actionsTarget: SavedRetrospective?
    /// Cartão esperando a confirmação para apagar (00d).
    var deletionTarget: SavedRetrospective?

    private let store: any RetrospectiveStore

    init(store: any RetrospectiveStore) {
        self.store = store
        load()
    }

    var isEmpty: Bool { retrospectives.isEmpty }

    var cards: [Card] { retrospectives.map { Self.card($0) } }

    func retrospective(id: SavedRetrospective.ID) -> SavedRetrospective? {
        retrospectives.first { $0.id == id }
    }

    func load() {
        retrospectives = (try? store.load()) ?? []
    }

    /// Guarda a retrospectiva que acabou de ser feita e devolve a versão salva (sem texto de mensagem).
    @discardableResult
    func save(_ result: WrappedResult) -> SavedRetrospective {
        let saved = SavedRetrospective(result: result)
        try? store.save(saved)
        load()
        return saved
    }

    func showActions(for id: SavedRetrospective.ID) {
        actionsTarget = retrospective(id: id)
    }

    /// "Apagar retrospectiva" no menu: fecha o menu e pede confirmação.
    func requestDeletion() {
        deletionTarget = actionsTarget
        actionsTarget = nil
    }

    func cancelDeletion() {
        deletionTarget = nil
    }

    func confirmDeletion() {
        guard let deletionTarget else { return }
        try? store.delete(id: deletionTarget.id)
        self.deletionTarget = nil
        load()
    }

    /// "Apagar a retrospectiva com Nicole?" / "… com Rolê de sexta?".
    func deletionTitle(for retrospective: SavedRetrospective) -> String {
        "Apagar a retrospectiva com \(Self.card(retrospective).title)?"
    }

    // MARK: - Textos do cartão

    private static func card(_ retrospective: SavedRetrospective) -> Card {
        let stats = retrospective.stats
        let others = stats.participants.filter { $0 != stats.exporter }
        let year = ChatCalendar.calendar.component(.year, from: stats.period.end).formatted(.number.grouping(.never))
        return Card(
            id: retrospective.id,
            isGroup: stats.isGroup,
            tag: "\(stats.isGroup ? "Grupo" : "Individual") · \(year)",
            title: title(stats: stats, others: others),
            highlight: stats.messages.total == 1 ? "1 mensagem" : "\(stats.messages.total.formatted()) mensagens",
            participants: others.isEmpty ? stats.participants : others
        )
    }

    /// Grupo: o nome do grupo. A dois: a outra pessoa (sem saber quem exportou, o nome do arquivo).
    private static func title(stats: WrappedStats, others: [String]) -> String {
        if stats.isGroup { return stats.title ?? "Grupo" }
        if stats.exporter != nil, let other = others.first { return other }
        return stats.title ?? stats.participants.joined(separator: " & ")
    }
}

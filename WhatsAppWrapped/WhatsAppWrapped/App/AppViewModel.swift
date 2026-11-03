//
//  AppViewModel.swift
//  WhatsAppWrapped
//
//  Navegação entre as partes do app: minhas retrospectivas (00), onboarding (01–02), importação (03–07),
//  slides e resumo. O que acontece dentro de cada parte fica no view model dela.
//
//  Primeira vez: onboarding → como exportar → envio/loading → slides → resumo.
//  Depois: minhas retrospectivas → "+ Nova retrospectiva" → como exportar → …
//  Pelo compartilhar do WhatsApp: direto para o loading. A retrospectiva é salva ao abrir os slides,
//  então quem chega assim na primeira vez volta para a lista, sem passar pelo onboarding.
//

import Foundation
import Observation

@Observable
final class AppViewModel {
    enum Step: Equatable {
        case retrospectives // 00
        case onboarding     // 01
        case exportGuide    // 02
        case importing      // 03–07
        case wrapped        // slides
        case summary        // 21
    }

    /// Abre o WhatsApp no botão da tela 02.
    static let whatsAppURL = URL(string: "whatsapp://")!

    private(set) var step: Step
    let importer: ImportViewModel
    let retrospectives: RetrospectivesViewModel
    /// Retrospectiva aberta nos slides ou no resumo: a que acabou de ser feita ou uma da lista.
    private(set) var current: WrappedResult?

    init(phraseGenerator: any SlidePhraseGenerator, store: any RetrospectiveStore) {
        importer = ImportViewModel(phraseGenerator: phraseGenerator)
        retrospectives = RetrospectivesViewModel(store: store)
        step = retrospectives.isEmpty ? .onboarding : .retrospectives
    }

    func start() {
        step = .exportGuide
    }

    /// "Prefiro salvar em arquivos" (02) e "Já exportei minha conversa" (01): tela de enviar o arquivo.
    func showFilePicker() {
        step = .importing
    }

    /// "+ Nova retrospectiva" e "Rebobinar": volta para o passo a passo de exportar.
    func newRetrospective() {
        importer.reset()
        step = .exportGuide
    }

    func goBack() {
        switch step {
        case .exportGuide: step = retrospectives.isEmpty ? .onboarding : .retrospectives
        case .importing where importer.phase == .chooseFile: step = .exportGuide
        case .wrapped, .summary: showRetrospectives()
        case .retrospectives, .onboarding, .importing: break
        }
    }

    /// Arquivo compartilhado do WhatsApp (`onOpenURL`). Pode chegar em qualquer tela.
    func importFile(_ url: URL) {
        step = .importing
        importer.importFile(url)
    }

    /// "Ver minha retrospectiva" (07): guarda os números na lista e abre os slides.
    func showWrapped() {
        guard let result = importer.result else { return }
        current = retrospectives.save(result).result
        step = .wrapped
    }

    func showRetrospectives() {
        retrospectives.load()
        step = retrospectives.isEmpty ? .onboarding : .retrospectives
    }

    /// "Ver resumo" ou toque no cartão.
    func openSummary(_ retrospective: SavedRetrospective) {
        current = retrospective.result
        step = .summary
    }

    /// "Rever histórias" no menu.
    func replay(_ retrospective: SavedRetrospective) {
        current = retrospective.result
        step = .wrapped
    }

    /// Fim dos slides.
    func showSummary() {
        guard current != nil else { return }
        step = .summary
    }

    /// "Ver de novo" no resumo.
    func replayCurrent() {
        guard current != nil else { return }
        step = .wrapped
    }

    /// Começa uma nova retrospectiva, com outra conversa.
    func startOver() {
        importer.reset()
        step = .importing
    }
}

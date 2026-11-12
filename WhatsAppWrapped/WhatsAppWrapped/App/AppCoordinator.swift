//
//  AppCoordinator.swift
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
final class AppCoordinator {
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
    /// Slides em andamento. Recriado a cada vez que os slides começam do primeiro.
    private(set) var wrapped: WrappedViewModel?

    init(
        phraseGenerator: any SlidePhraseGenerator,
        store: any RetrospectiveStore,
        purchases: any RetrospectivePurchases,
        freeTrial: any FreeTrial
    ) {
        importer = ImportViewModel(phraseGenerator: phraseGenerator, purchases: purchases, freeTrial: freeTrial)
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
        case .importing where importer.phase == .paywall:
            importer.reset()
            showRetrospectives()
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
    /// Esta primeira vez usa o resultado completo; a versão salva não tem o trecho do textão.
    func showWrapped() {
        guard let result = importer.result else { return }
        retrospectives.save(result)
        play(result)
    }

    /// "Minhas retrospectivas" no resumo e o gesto de voltar dos slides. Sempre abre a lista (00a), ou o
    /// estado vazio (00b) se nada foi salvo; o onboarding só aparece ao abrir o app pela primeira vez.
    func showRetrospectives() {
        retrospectives.load()
        step = .retrospectives
    }

    /// "Ver resumo" ou toque no cartão.
    func openSummary(_ retrospective: SavedRetrospective) {
        current = retrospective.result
        step = .summary
    }

    /// "Rever histórias" no menu.
    func replay(_ retrospective: SavedRetrospective) {
        play(retrospective.result)
    }

    /// "Ver o ano inteiro" no resumo da retrospectiva grátis. Logo depois de fazê-la, a conversa ainda está
    /// na memória e vai direto para a compra; aberta pela lista, é preciso exportar de novo.
    func unlockFullYear() {
        if importer.startFullYear() {
            step = .importing
        } else {
            newRetrospective()
        }
    }

    /// Fim dos slides.
    func showSummary() {
        guard current != nil else { return }
        step = .summary
    }

    private func play(_ result: WrappedResult) {
        current = result
        wrapped = WrappedViewModel(result: result) { [weak self] in self?.showSummary() }
        step = .wrapped
    }
}

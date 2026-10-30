//
//  AppViewModel.swift
//  WhatsAppWrapped
//
//  Navegação entre as partes do app: onboarding (01–02), importação (03–07) e slides.
//  O que acontece dentro da importação fica no `ImportViewModel`.
//

import Foundation
import Observation

@Observable
final class AppViewModel {
    enum Step: Equatable {
        case onboarding     // 01
        case exportGuide    // 02
        case importing      // 03–07
        case wrapped        // slides
    }

    /// Abre o WhatsApp no botão da tela 02.
    static let whatsAppURL = URL(string: "whatsapp://")!

    private(set) var step: Step = .onboarding
    let importer: ImportViewModel

    init(phraseGenerator: any SlidePhraseGenerator) {
        importer = ImportViewModel(phraseGenerator: phraseGenerator)
    }

    func start() {
        step = .exportGuide
    }

    /// "Prefiro salvar em arquivos".
    func showFilePicker() {
        step = .importing
    }

    func goBack() {
        switch step {
        case .exportGuide: step = .onboarding
        case .importing where importer.phase == .chooseFile: step = .exportGuide
        case .onboarding, .importing, .wrapped: break
        }
    }

    /// Arquivo compartilhado do WhatsApp (`onOpenURL`). Pode chegar em qualquer tela.
    func importFile(_ url: URL) {
        step = .importing
        importer.importFile(url)
    }

    func showWrapped() {
        guard importer.result != nil else { return }
        step = .wrapped
    }

    /// Começa uma nova retrospectiva, com outra conversa.
    func startOver() {
        importer.reset()
        step = .importing
    }
}

//
//  AIConsent.swift
//  WhatsAppWrapped
//
//  Permissão para mandar o resumo da conversa ao Gemini (diretriz 5.1.2(i) da App Store): a pessoa
//  vê o que vai e para quem antes do primeiro envio. A resposta fica guardada (a pergunta aparece uma vez só)
//  e pode ser trocada a qualquer momento no cartão "Frases com IA" de "Minhas retrospectivas".
//

import Foundation
import Observation

@Observable
final class AIConsent {
    enum Decision: String {
        case allowed
        case declined
    }

    /// nil enquanto a pessoa não respondeu: a tela de permissão aparece antes da próxima retrospectiva.
    private(set) var decision: Decision?

    /// nil guarda só na memória (previews).
    @ObservationIgnored private let defaults: UserDefaults?
    private static let key = "aiConsentDecision"

    init(defaults: UserDefaults? = .standard) {
        self.defaults = defaults
        decision = defaults?.string(forKey: Self.key).flatMap(Decision.init)
    }

    var isAllowed: Bool { decision == .allowed }

    func decide(_ decision: Decision) {
        self.decision = decision
        defaults?.set(decision.rawValue, forKey: Self.key)
    }

    #if DEBUG
    /// `-resetAIConsent` nos argumentos do scheme: mostra a tela de permissão de novo.
    func reset() {
        decision = nil
        defaults?.removeObject(forKey: Self.key)
    }
    #endif
}

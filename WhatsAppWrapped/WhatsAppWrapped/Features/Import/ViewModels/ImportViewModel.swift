//
//  ImportViewModel.swift
//  WhatsAppWrapped
//
//  Telas 03–07: escolher o arquivo, analisar a conversa (números + frases da IA) e avisar que ficou pronto.
//  O arquivo pode chegar pela tela 03 ou pelo compartilhamento do WhatsApp; os dois caminhos terminam em `importFile(_:)`.
//
//  Modelo pago: a primeira retrospectiva é grátis e cobre os últimos 30 dias. Depois, cada retrospectiva
//  completa (12 meses) é uma compra. Quem tem uma compra ainda não usada vai direto para a análise;
//  quem não tem vê a tela de compra. A conversa fica na memória até `reset()`, para dar para comprar
//  o ano inteiro logo depois de ver a versão grátis sem exportar de novo.
//

import Foundation
import Observation

@Observable
final class ImportViewModel {
    enum Phase: Equatable {
        case chooseFile     // 03 e 03b (com erro)
        case loading        // 04–06
        case paywall        // compra da retrospectiva completa
        case ready          // 07 Prontinho
    }

    /// Erro mostrado no card da tela 03b.
    struct Failure: Equatable {
        let title: String
        let message: String
        /// A conversa já foi lida e só a IA falhou: "Tentar de novo" gera de novo sem escolher o arquivo.
        var canRetry = false
    }

    /// As três frases de carregamento (04–06, 2 s cada) aparecem mesmo quando a análise é rápida.
    static let minimumLoadingTime: Duration = .seconds(6)

    private(set) var phase: Phase = .chooseFile
    private(set) var result: WrappedResult?
    /// Arquivo escolhido na tela 03, antes de tocar em "Analisar conversa".
    private(set) var selectedFile: URL?
    private(set) var failure: Failure?
    /// Aviso na tela de compra (App Store fora do ar, compra esperando aprovação).
    private(set) var purchaseMessage: String?
    private(set) var isPurchasing = false
    /// Buscando o preço na App Store.
    private(set) var isLoadingPrice = false

    private let phraseGenerator: any SlidePhraseGenerator
    private let purchases: any RetrospectivePurchases
    private let freeTrial: any FreeTrial
    /// Conversa lida, guardada só na memória e só até `reset()`.
    private var chat: Chat?
    private var importTask: Task<Void, Never>?

    init(phraseGenerator: any SlidePhraseGenerator, purchases: any RetrospectivePurchases, freeTrial: any FreeTrial) {
        self.phraseGenerator = phraseGenerator
        self.purchases = purchases
        self.freeTrial = freeTrial
    }

    /// Ano mostrado em "Sua retrospectiva 2026 está pronta" (o fim do período analisado).
    var retrospectiveYear: Int? {
        result.map { ChatCalendar.calendar.component(.year, from: $0.stats.period.end) }
    }

    var isTrialResult: Bool { result?.isTrial ?? false }

    /// "R$ 5,90", vindo da App Store.
    var price: String? { purchases.displayPrice }

    /// Tela 03: guarda o arquivo até a pessoa tocar em "Analisar conversa".
    func selectFile(_ url: URL) {
        selectedFile = url
        failure = nil
    }

    func analyzeSelectedFile() {
        guard let selectedFile else { return }
        importFile(selectedFile)
    }

    /// "Tentar de novo" no card de erro. Se só a IA tinha falhado, gera de novo com a conversa já lida.
    func dismissFailure() {
        let canRetry = failure?.canRetry ?? false
        failure = nil
        selectedFile = nil
        if canRetry, let chat { run { try await self.continueWith(chat) } }
    }

    /// Volta para a tela 03 sem nada, para analisar outra conversa.
    func reset() {
        importTask?.cancel()
        result = nil
        chat = nil
        selectedFile = nil
        failure = nil
        purchaseMessage = nil
        isPurchasing = false
        phase = .chooseFile
    }

    func importFile(_ url: URL) {
        chat = nil
        run {
            let chat = try await WrappedService.loadChat(fileURL: url)
            self.chat = chat
            try await self.continueWith(chat)
        }
    }

    /// "Ver o ano inteiro" depois da versão grátis. false quando a conversa não está mais na memória
    /// (retrospectiva aberta pela lista): aí é preciso exportar de novo.
    func startFullYear() -> Bool {
        guard let chat else { return false }
        result = nil
        if purchases.hasCredit {
            run { try await self.generate(from: chat, isTrial: false) }
        } else {
            showPaywall()
        }
        return true
    }

    /// Botão de compra da tela de pagamento.
    func buy() {
        guard let chat, !isPurchasing else { return }
        purchaseMessage = nil
        isPurchasing = true
        importTask?.cancel()
        importTask = Task {
            defer { isPurchasing = false }
            let outcome: PurchaseOutcome
            do {
                outcome = try await purchases.purchase()
            } catch {
                purchaseMessage = (error as? LocalizedError)?.errorDescription
                    ?? "Não conseguimos concluir a compra. Tente de novo."
                return
            }
            switch outcome {
            case .purchased:
                isPurchasing = false
                await runGeneration { try await self.generate(from: chat, isTrial: false) }
            case .pending:
                purchaseMessage = "Sua compra está esperando aprovação. Quando for aprovada, é só abrir a conversa de novo."
            case .cancelled:
                break
            }
        }
    }

    /// Com uma compra não usada, a retrospectiva completa sai direto. Sem compra, a primeira é a grátis
    /// de 30 dias e as próximas passam pela tela de compra.
    private func continueWith(_ chat: Chat) async throws {
        if purchases.hasCredit {
            try await generate(from: chat, isTrial: false)
        } else if freeTrial.isAvailable {
            try await generate(from: chat, isTrial: true)
        } else {
            showPaywall()
        }
    }

    private func showPaywall() {
        purchaseMessage = nil
        phase = .paywall
        guard purchases.displayPrice == nil else { return }
        isLoadingPrice = true
        Task {
            await purchases.prepare()
            isLoadingPrice = false
            if purchases.displayPrice == nil, purchaseMessage == nil {
                purchaseMessage = "Não conseguimos carregar o preço. Confira sua internet e toque em Desbloquear para tentar de novo."
            }
        }
    }

    /// Só gasta a grátis ou consome a compra depois que a retrospectiva ficou pronta.
    private func generate(from chat: Chat, isTrial: Bool) async throws {
        phase = .loading
        async let minimumLoading: Void = Task.sleep(for: Self.minimumLoadingTime)
        let stats = await WrappedService.makeStats(for: chat, isTrial: isTrial)
        let phrases = try await SlidePhraseService.phrases(for: stats, using: phraseGenerator)
        try await minimumLoading

        if isTrial {
            freeTrial.markUsed()
        } else {
            await purchases.consumeCredit()
        }
        result = WrappedResult(stats: stats, phrases: phrases, isTrial: isTrial)
        phase = .ready
    }

    /// Roda uma etapa da importação, cancelando a anterior: um arquivo novo substitui o que estava em andamento.
    private func run(_ work: @escaping @MainActor () async throws -> Void) {
        importTask?.cancel()
        importTask = Task { await runGeneration(work) }
    }

    private func runGeneration(_ work: () async throws -> Void) async {
        failure = nil
        phase = .loading
        do {
            try await work()
            selectedFile = nil
        } catch is CancellationError {
            return
        } catch is SlidePhraseService.Unavailable {
            failure = Failure(
                title: "Não deu para criar sua retrospectiva agora",
                message: purchases.hasCredit
                    ? "Confira sua internet e tente de novo. Sua compra continua guardada."
                    : "Confira sua internet e tente de novo.",
                canRetry: true
            )
            selectedFile = nil
            phase = .chooseFile
        } catch {
            let importError = error as? ChatImporter.ImportError ?? .unreadableFile
            failure = Failure(title: importError.title, message: importError.localizedDescription)
            selectedFile = nil
            phase = .chooseFile
        }
    }
}

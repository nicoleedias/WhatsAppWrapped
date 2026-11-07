//
//  ImportViewModel.swift
//  WhatsAppWrapped
//
//  Telas 03–07: escolher o arquivo, analisar a conversa (números + frases da IA) e avisar que ficou pronto.
//  O arquivo pode chegar pela tela 03 ou pelo compartilhamento do WhatsApp; os dois caminhos terminam em `importFile(_:)`.
//

import Foundation
import Observation

@Observable
final class ImportViewModel {
    enum Phase: Equatable {
        case chooseFile     // 03 e 03b (com erro)
        case loading        // 04–06
        case ready          // 07 Prontinho
    }

    /// Erro mostrado no card da tela 03b.
    struct Failure: Equatable {
        let title: String
        let message: String
    }

    /// As três frases de carregamento (04–06, 2 s cada) aparecem mesmo quando a análise é rápida.
    static let minimumLoadingTime: Duration = .seconds(6)

    private(set) var phase: Phase = .chooseFile
    private(set) var result: WrappedResult?
    /// Arquivo escolhido na tela 03, antes de tocar em "Analisar conversa".
    private(set) var selectedFile: URL?
    private(set) var failure: Failure?

    private let phraseGenerator: any SlidePhraseGenerator
    private var importTask: Task<Void, Never>?

    init(phraseGenerator: any SlidePhraseGenerator) {
        self.phraseGenerator = phraseGenerator
    }

    /// Ano mostrado em "Sua retrospectiva 2026 está pronta" (o fim do período analisado).
    var retrospectiveYear: Int? {
        result.map { ChatCalendar.calendar.component(.year, from: $0.stats.period.end) }
    }

    /// Tela 03: guarda o arquivo até a pessoa tocar em "Analisar conversa".
    func selectFile(_ url: URL) {
        selectedFile = url
        failure = nil
    }

    func analyzeSelectedFile() {
        guard let selectedFile else { return }
        importFile(selectedFile)
    }

    /// "Tentar de novo" no card de erro.
    func dismissFailure() {
        failure = nil
        selectedFile = nil
    }

    /// Volta para a tela 03 sem nada, para analisar outra conversa.
    func reset() {
        importTask?.cancel()
        result = nil
        selectedFile = nil
        failure = nil
        phase = .chooseFile
    }

    func importFile(_ url: URL) {
        // Um arquivo novo substitui qualquer importação em andamento.
        importTask?.cancel()
        failure = nil
        phase = .loading

        importTask = Task {
            do {
                async let minimumLoading: Void = Task.sleep(for: Self.minimumLoadingTime)
                let stats = try await WrappedService.makeStats(fileURL: url)
                let phrases = await SlidePhraseService.phrases(for: stats, using: phraseGenerator)
                try await minimumLoading

                result = WrappedResult(stats: stats, phrases: phrases)
                selectedFile = nil
                phase = .ready
            } catch is CancellationError {
                return
            } catch {
                let importError = error as? ChatImporter.ImportError ?? .unreadableFile
                failure = Failure(title: importError.title, message: importError.localizedDescription)
                selectedFile = nil
                phase = .chooseFile
            }
        }
    }
}

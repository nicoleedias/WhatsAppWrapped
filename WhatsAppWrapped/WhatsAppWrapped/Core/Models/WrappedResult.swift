//
//  WrappedResult.swift
//  WhatsAppWrapped
//
//  Resultado final da análise: estatísticas + frases. É o que os slides recebem.
//

import Foundation

/// O que os slides precisam: os números calculados no aparelho e as frases da IA.
nonisolated struct WrappedResult: Sendable {
    let stats: WrappedStats
    let phrases: SlidePhrases
}

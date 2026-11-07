//
//  CallAnalyzer.swift
//  WhatsAppWrapped
//
//  Slides 17b–17c: ligações de voz e vídeo, atendidas e perdidas, duração média e máxima.
//

import Foundation

/// Slide de ligações: quantas, voz × vídeo e duração.
nonisolated enum CallAnalyzer {
    static func analyze(_ calls: [Call]) -> CallStats {
        let durations = calls.compactMap(\.duration)
        var byCaller: [String: Int] = [:]
        for call in calls {
            byCaller[call.caller, default: 0] += 1
        }

        return CallStats(
            total: calls.count,
            voice: calls.count(where: { !$0.isVideo }),
            video: calls.count(where: \.isVideo),
            answered: durations.count,
            missed: calls.count(where: \.isMissed),
            averageDuration: durations.isEmpty ? nil : durations.reduce(0, +) / Double(durations.count),
            longestDuration: durations.max(),
            byCaller: PersonCount.ranking(byCaller)
        )
    }
}

//
//  WordRanking.swift
//  WhatsAppWrapped
//
//  Slide 13: top 3 palavras em cards. A #1 é tinta com número e barra em lima; as outras, creme com número coral escuro.
//  A barra mostra a contagem em relação à #1 e cresce da esquerda.
//

import SwiftUI

struct WordRanking: View {
    let words: [WordStats.WordCount]

    private var topCount: Int { max(words.first?.count ?? 1, 1) }

    var body: some View {
        VStack(spacing: 12) {
            ForEach(Array(words.prefix(3).enumerated()), id: \.element) { index, word in
                WordRankingRow(
                    rank: index + 1,
                    word: word.word,
                    count: word.count,
                    fraction: Double(word.count) / Double(topCount)
                )
                .entrance(delay: 0.2 + Double(index) * Motion.cascadeStep)
            }
        }
    }
}

struct WordRankingRow: View {
    let rank: Int
    let word: String
    let count: Int
    /// 0…1, em relação à palavra #1.
    let fraction: Double

    private var isTop: Bool { rank == 1 }

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                Text(rank, format: .number)
                    .textStyle(.rankValue)
                    .foregroundStyle(isTop ? Color.lime : .coralDeep)
                Text(word)
                    .textStyle(isTop ? .heading2 : .title, minimumScale: 0.6)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(count, format: .number)
                    .textStyle(.headline)
            }
            Capsule()
                .fill(isTop ? Color.cream : Color.ink.opacity(0.15))
                .frame(height: 8)
                .overlay(alignment: .leading) {
                    GeometryReader { geometry in
                        Capsule()
                            .fill(isTop ? Color.lime : .ink)
                            .frame(width: geometry.size.width * min(max(fraction, 0), 1))
                            .barGrowth(delay: 0.5 + Double(rank) * Motion.cascadeStep)
                    }
                }
        }
        .foregroundStyle(isTop ? Color.cream : .ink)
        .padding(20)
        .background(isTop ? Color.ink : .cream, in: .rect(cornerRadius: 24))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(rank)º lugar: \(word), \(count.formatted()) vezes")
    }
}

#Preview {
    WordRanking(words: [
        .init(word: "kkkkk", count: 2104),
        .init(word: "então", count: 1310),
        .init(word: "mds", count: 987),
    ])
    .padding(32)
    .background(.lime)
}

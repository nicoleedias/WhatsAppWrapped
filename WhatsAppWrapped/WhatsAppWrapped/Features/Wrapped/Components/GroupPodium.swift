//
//  GroupPodium.swift
//  WhatsAppWrapped
//
//  Slide 19: pódio de quem mais fala no grupo, na ordem 2º · 1º · 3º. Medalha, nome e total em cima
//  de cada bloco (manteiga 150, creme 230, rosa 100), que cresce da base.
//

import SwiftUI

struct GroupPodium: View {
    /// Top 3 em ordem decrescente (`MessageStats.podium`).
    let podium: [PersonCount]
    /// Nome mostrado no lugar do nome do arquivo (ex.: quem exportou vira "Você").
    var displayName: (String) -> String = { $0 }

    private struct Place {
        let medal: String
        let height: CGFloat
        let fill: Color
    }

    private static let places = [
        Place(medal: "🥇", height: 230, fill: .cream),
        Place(medal: "🥈", height: 150, fill: .butter),
        Place(medal: "🥉", height: 100, fill: .rose),
    ]

    /// 2º, 1º, 3º — quem tiver no pódio.
    private var columns: [(rank: Int, person: PersonCount)] {
        let ranked = Array(podium.prefix(3).enumerated()).map { (rank: $0.offset, person: $0.element) }
        return [1, 0, 2].compactMap { index in ranked.first { $0.rank == index } }
    }

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            ForEach(columns, id: \.rank) { column in
                PodiumColumn(
                    medal: Self.places[column.rank].medal,
                    name: displayName(column.person.name),
                    count: column.person.count,
                    blockHeight: Self.places[column.rank].height,
                    fill: Self.places[column.rank].fill,
                    delay: 0.3 + Double(2 - column.rank) * Motion.cascadeStep * 2
                )
            }
        }
    }
}

private struct PodiumColumn: View {
    let medal: String
    let name: String
    let count: Int
    let blockHeight: CGFloat
    let fill: Color
    let delay: Double

    var body: some View {
        VStack(spacing: 8) {
            VStack(spacing: 0) {
                Text(medal)
                    .font(.system(size: 32))
                    .accessibilityHidden(true)
                Text(name)
                    .textStyle(.podiumName, minimumScale: 0.6)
                Text(count, format: .number)
                    .textStyle(.captionSemiBold)
            }
            .foregroundStyle(.ink)
            .entrance(delay: delay + 0.3)
            UnevenRoundedRectangle(topLeadingRadius: 24, topTrailingRadius: 24)
                .fill(fill)
                .frame(height: blockHeight)
                .columnGrowth(delay: delay)
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    GroupPodium(podium: [
        PersonCount(name: "Bia", count: 4212),
        PersonCount(name: "Rafa", count: 3108),
        PersonCount(name: "Nicole", count: 2877),
    ]) { $0 == "Nicole" ? "Você" : $0 }
    .padding(32)
    .background(.coral)
}

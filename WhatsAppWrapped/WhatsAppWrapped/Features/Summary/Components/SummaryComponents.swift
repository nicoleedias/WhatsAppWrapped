//
//  SummaryComponents.swift
//  WhatsAppWrapped
//
//  Slide 21 (resumo final): cabeçalho com as fotos sobrepostas, o card lima com o total de mensagens,
//  a grade 2×2 de destaques e a linha de "quem demora mais". Tudo sobe 24 pt em cascata.
//

import SwiftUI

// MARK: - Cabeçalho

/// "Você & Nicole · 💬 sua conversa em 2026" com as fotos sobrepostas.
struct SummaryHeader: View {
    let participants: [String]
    let title: String
    /// "💬 sua conversa em 2026", "💬 6 pessoas · 2026".
    let subtitle: String

    var body: some View {
        HStack(spacing: 16) {
            AvatarStack(names: participants)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .textStyle(.title, minimumScale: 0.7)
                    .accessibilityAddTraits(.isHeader)
                Text(subtitle)
                    .textStyle(.bodySSemiBold)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .entrance(delay: 0.1, offset: 24)
    }
}

/// Fotos sobrepostas. Duas pessoas: 64 pt. Grupo: 44 pt, até 3 fotos e um "+N" com o resto.
struct AvatarStack: View {
    let names: [String]
    @Environment(\.backdrop) private var backdrop

    private static let fills: [Color] = [.lilac, .rose]
    private static let maxShown = 3

    private var isGroup: Bool { names.count > 2 }
    private var size: AvatarView.Size { isGroup ? .medium : .large }
    private var overlap: CGFloat { isGroup ? -14 : -20 }
    private var shown: [String] { Array(names.prefix(isGroup ? Self.maxShown : 2)) }
    private var hiddenCount: Int { names.count - shown.count }

    var body: some View {
        HStack(spacing: overlap) {
            ForEach(Array(shown.enumerated()), id: \.offset) { index, name in
                AvatarView(name: name, size: size, fill: Self.fills[index % Self.fills.count])
            }
            if hiddenCount > 0 {
                Text("+\(hiddenCount)")
                    .textStyle(size.textStyle)
                    .foregroundStyle(.ink)
                    .frame(width: size.rawValue, height: size.rawValue)
                    .background(Self.fills[shown.count % Self.fills.count], in: .circle)
                    .overlay { Circle().strokeBorder(backdrop.color, lineWidth: 3) }
                    .accessibilityLabel("mais \(hiddenCount) pessoas")
            }
        }
        .accessibilityElement(children: .combine)
    }
}

// MARK: - Total

/// Card lima de mensagem recebida: total de mensagens + "mensagens trocadas ✓✓" e o 💬 grande.
struct SummaryHero: View {
    let messageCount: Int

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                Text(messageCount, format: .number)
                    .textStyle(.numberSummary, minimumScale: 0.5)
                HStack(spacing: 8) {
                    Text("mensagens trocadas")
                        .textStyle(.bodyMSemiBold)
                    Text("✓✓")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Color.night.opacity(0.7))
                        .accessibilityHidden(true)
                }
            }
            Spacer(minLength: 8)
            Text("💬")
                .font(.system(size: 64))
                .accessibilityHidden(true)
        }
        .foregroundStyle(.ink)
        .padding(24)
        .background(.lime, in: BubbleShape(radius: 32, tail: .bottomLeading))
        .entrance(delay: 0.18, offset: 24)
        .accessibilityElement(children: .combine)
    }
}

// MARK: - Destaques

/// Grade 2×2 de `StatCard` (emoji #1, risadas, sequência, horário de pico), entrando um card por vez.
struct SummaryStatGrid: View {
    struct Stat: Hashable {
        let emoji: String
        let value: String
        let caption: String
        let tint: StatCard.Tint
    }

    /// Até 4, na ordem de leitura.
    let stats: [Stat]

    private var rows: [[Stat]] {
        stride(from: 0, to: min(stats.count, 4), by: 2).map { Array(stats[$0..<min($0 + 2, stats.count)]) }
    }

    var body: some View {
        Grid(horizontalSpacing: 8, verticalSpacing: 8) {
            ForEach(rows.indices, id: \.self) { row in
                GridRow {
                    ForEach(Array(rows[row].enumerated()), id: \.element) { column, stat in
                        StatCard(emoji: stat.emoji, value: stat.value, caption: stat.caption, tint: stat.tint)
                            .entrance(delay: 0.26 + Double(row * 2 + column) * Motion.cascadeStep, offset: 24)
                    }
                }
            }
        }
    }
}

/// Linha creme com o 🐢: "Quem demora mais / Nicole · 3h42min".
struct SummaryHighlight: View {
    var emoji = "🐢"
    var title = "Quem demora mais"
    /// "Nicole · 3h42min".
    let value: String

    var body: some View {
        HStack(spacing: 16) {
            Text(emoji)
                .font(.system(size: 32))
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 0) {
                Text(title)
                    .textStyle(TextStyle(size: 14, weight: .medium, relativeTo: .subheadline))
                Text(value)
                    .textStyle(.rankValue)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .foregroundStyle(.ink)
        .padding(16)
        .background(.cream, in: .rect(cornerRadius: 28))
        .entrance(delay: 0.58, offset: 24)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    ScreenContainer(backdrop: .plum) {
        BurstDecoration.summary
    } content: {
        VStack(spacing: 8) {
            SummaryHeader(participants: ["Você", "Nicole"], title: "Você & Nicole", subtitle: "💬 sua conversa em 2026")
            SummaryHero(messageCount: 30597)
            SummaryStatGrid(stats: [
                .init(emoji: "😭", value: "1.365×", caption: "emoji #1", tint: .rose),
                .init(emoji: "😂", value: "2.847", caption: "risadas", tint: .butter),
                .init(emoji: "🔥", value: "95 dias", caption: "de sequência", tint: .coral),
                .init(emoji: "🦉", value: "23h47", caption: "horário de pico", tint: .lilac),
            ])
            SummaryHighlight(value: "Nicole · 3h42min")
        }
        Spacer()
        Button("Compartilhar") {}.buttonStyle(.rebobina(.primaryOnDark))
        Button("Ver de novo") {}.buttonStyle(.rebobina(.secondary))
    }
}

#Preview("Grupo") {
    AvatarStack(names: ["Bia", "Rafa", "Lu", "Caio", "Tânia", "Nicole"])
        .padding()
        .background(.plum)
        .environment(\.backdrop, .plum)
}

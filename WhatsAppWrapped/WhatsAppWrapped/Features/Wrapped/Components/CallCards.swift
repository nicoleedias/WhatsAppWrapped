//
//  CallCards.swift
//  WhatsAppWrapped
//
//  Slide 17c: os dois cards lado a lado (voz em creme com pontinha à esquerda, vídeo em tinta com pontinha
//  à direita), com selo, porcentagem, total e barra; e o balão de tinta com a duração média, com o ponto
//  lima piscando como "gravando".
//

import SwiftUI

struct CallTypeCard: View {
    enum Kind {
        case voice, video

        var emoji: String { self == .voice ? "📞" : "🎥" }
        var caption: String { self == .voice ? "ligações de voz" : "ligações de vídeo" }
        var background: Color { self == .voice ? .cream : .ink }
        var foreground: Color { self == .voice ? .ink : .cream }
        var accent: Color { self == .voice ? .lime : .rose }
        var tail: BubbleShape.Tail { self == .voice ? .bottomLeading : .bottomTrailing }
        /// Ordem de entrada no slide.
        var delay: Double { self == .voice ? 0.2 : 0.28 }
    }

    let kind: Kind
    let count: Int
    /// 0…100.
    let percentage: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(kind.emoji)
                    .textStyle(.bodyL)
                    .frame(width: 40, height: 40)
                    .background(kind.accent, in: .circle)
                    .accessibilityHidden(true)
                Spacer()
                Text("\(percentage)%")
                    .textStyle(.label)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(kind.foreground.opacity(0.12), in: .rect(cornerRadius: 12))
            }
            VStack(alignment: .leading, spacing: 0) {
                Text(count, format: .number)
                    .textStyle(.numberCard, minimumScale: 0.5)
                Text(kind.caption)
                    .textStyle(.bodyS)
            }
            Capsule()
                .fill(kind.foreground.opacity(0.15))
                .frame(height: 6)
                .overlay(alignment: .leading) {
                    GeometryReader { geometry in
                        Capsule()
                            .fill(kind.accent)
                            .frame(width: geometry.size.width * Double(min(max(percentage, 0), 100)) / 100)
                            .barGrowth(delay: kind.delay + 0.3)
                    }
                }
        }
        .foregroundStyle(kind.foreground)
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(kind.background, in: BubbleShape(radius: 28, tail: kind.tail))
        .entrance(delay: kind.delay, offset: 24)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(count.formatted()) \(kind.caption), \(percentage)%")
    }
}

struct CallDurationCard: View {
    /// "14:07".
    let average: String
    /// "minutos por chamada · a maior durou 3h12".
    let detail: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 8) {
                RecordingDot()
                Text("Duração média")
                    .textStyle(.label)
            }
            Text(average)
                .textStyle(.numberTimer, minimumScale: 0.5)
                .foregroundStyle(.lime)
            Text(detail)
                .textStyle(.bodyS)
        }
        .foregroundStyle(.cream)
        .padding(.horizontal, 24)
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ink, in: BubbleShape(radius: 32, tail: .bottomLeading))
        .popEntrance(delay: 0.4, from: 0.92)
        .accessibilityElement(children: .combine)
    }
}

/// Ponto lima de 10 pt piscando (1 → 0,2), duas vezes a cada 2 s.
private struct RecordingDot: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var isDimmed = false

    var body: some View {
        Circle()
            .fill(.lime)
            .frame(width: 10, height: 10)
            .opacity(isDimmed ? 0.2 : 1)
            .onAppear {
                guard !reduceMotion else { return }
                withAnimation(.easeInOut(duration: 0.5).repeatForever()) { isDimmed = true }
            }
            .accessibilityHidden(true)
    }
}

#Preview {
    VStack(spacing: 24) {
        HStack(alignment: .top, spacing: 12) {
            CallTypeCard(kind: .voice, count: 96, percentage: 75)
            CallTypeCard(kind: .video, count: 32, percentage: 25)
        }
        CallDurationCard(average: "14:07", detail: "minutos por chamada · a maior durou 3h12")
    }
    .padding(32)
    .background(.lilac)
}

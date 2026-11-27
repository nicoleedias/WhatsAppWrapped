//
//  ExportStepList.swift
//  WhatsAppWrapped
//
//  Lista numerada dos passos de exportação (tela 02): número em coral escuro, título e detalhe,
//  com uma linha entre os passos. Os passos entram em cascata.
//

import SwiftUI

struct ExportStepList: View {
    let steps: [ExportStep]

    var body: some View {
        VStack(spacing: 0) {
            ForEach(steps) { step in
                ExportStepRow(step: step)
                    .overlay(alignment: .top) {
                        if step.id != steps.first?.id { Rectangle().fill(.ink).frame(height: 1) }
                    }
                    .entrance(delay: 0.2 + Double(step.number - 1) * Motion.cascadeStep)
            }
        }
    }
}

struct ExportStepRow: View {
    let step: ExportStep

    var body: some View {
        HStack(spacing: 24) {
            Text(step.number, format: .number)
                .textStyle(TextStyle(size: 38, weight: .bold, lineHeight: 43, tracking: -0.38, relativeTo: .largeTitle))
                .foregroundStyle(.coralDeep)
            VStack(alignment: .leading, spacing: 4) {
                Text(step.title).textStyle(.button)
                Text(step.detail)
                    .textStyle(.bodyS)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        // 12 (e não 16) para os 4 passos caberem sem empurrar o título para cima no iPhone 17.
        .padding(.vertical, 12)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    ExportStepList(steps: ExportStep.all)
        .padding(32)
        .background(.cream)
}

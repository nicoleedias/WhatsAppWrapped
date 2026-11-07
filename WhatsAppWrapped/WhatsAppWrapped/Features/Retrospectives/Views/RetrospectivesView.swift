//
//  RetrospectivesView.swift
//  WhatsAppWrapped
//
//  00a–00d: "Minhas retrospectivas". A lista de cartões (ou o estado vazio), o menu de ações em
//  bottom sheet e a confirmação para apagar sobre o véu escuro.
//

import SwiftUI

struct RetrospectivesView: View {
    @Bindable var viewModel: RetrospectivesViewModel
    let openSummary: (SavedRetrospective) -> Void
    let replay: (SavedRetrospective) -> Void
    let newRetrospective: () -> Void

    @Environment(\.displayScale) private var displayScale
    @State private var shareImage: Image?

    var body: some View {
        ScreenContainer(backdrop: .cream) {
            BurstDecoration.retrospectives
        } content: {
            Text("Minhas retrospectivas")
                .textStyle(.heading2)
                .accessibilityAddTraits(.isHeader)
                .entrance()
            if viewModel.isEmpty {
                emptyContent
            } else {
                listContent
            }
        }
        .overlay { deletionOverlay }
        .animation(.easeOut(duration: Motion.fast), value: viewModel.deletionTarget?.id)
        .sheet(item: $viewModel.actionsTarget) { retrospective in
            RetrospectiveActions(
                shareImage: shareImage,
                openSummary: { act { openSummary(retrospective) } },
                replay: { act { replay(retrospective) } },
                delete: viewModel.requestDeletion
            )
            .presentationDetents([.height(311)])
            .presentationDragIndicator(.visible)
            .presentationBackground(.cream)
            .presentationCornerRadius(32)
            .task { renderShareImage(for: retrospective) }
        }
    }

    // MARK: - 00a

    @ViewBuilder
    private var listContent: some View {
        PrivacyNotice()
            .entrance(delay: 0.1)
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(Array(viewModel.cards.enumerated()), id: \.element.id) { index, card in
                    RetrospectiveCard(
                        card: card,
                        fill: RetrospectiveCard.fills[index % RetrospectiveCard.fills.count],
                        open: { open(card.id, with: openSummary) },
                        showActions: { viewModel.showActions(for: card.id) }
                    )
                    .entrance(delay: 0.2 + Double(min(index, 5)) * Motion.cascadeStep)
                }
            }
        }
        .scrollIndicators(.hidden)
        .scrollBounceBehavior(.basedOnSize)
        Button("+ Nova retrospectiva", action: newRetrospective)
            .buttonStyle(.rebobina(.primary))
    }

    // MARK: - 00b

    @ViewBuilder
    private var emptyContent: some View {
        Spacer(minLength: 0)
        EmptyRetrospectives()
        Spacer(minLength: 0)
        PrivacyNotice()
        Button("Rebobinar", action: newRetrospective)
            .buttonStyle(.rebobina(.primary))
    }

    // MARK: - 00d

    @ViewBuilder
    private var deletionOverlay: some View {
        if let target = viewModel.deletionTarget {
            ZStack {
                Color.ink.opacity(0.45)
                    .ignoresSafeArea()
                    .onTapGesture(perform: viewModel.cancelDeletion)
                    .accessibilityHidden(true)
                DeleteConfirmation(
                    title: viewModel.deletionTitle(for: target),
                    confirm: viewModel.confirmDeletion,
                    cancel: viewModel.cancelDeletion
                )
                .padding(32)
                .transition(.scale(scale: 0.92).combined(with: .opacity))
            }
            .transition(.opacity)
        }
    }

    // MARK: - Ações

    private func open(_ id: SavedRetrospective.ID, with action: (SavedRetrospective) -> Void) {
        guard let retrospective = viewModel.retrospective(id: id) else { return }
        action(retrospective)
    }

    /// Fecha o menu antes de trocar de tela.
    private func act(_ action: () -> Void) {
        viewModel.actionsTarget = nil
        action()
    }

    private func renderShareImage(for retrospective: SavedRetrospective) {
        shareImage = nil
        shareImage = SummaryCard.shareImage(for: SummaryViewModel(result: retrospective.result), scale: displayScale)
    }
}

#Preview("Lista") {
    RetrospectivesView(
        viewModel: RetrospectivesViewModel(store: PreviewRetrospectiveStore()),
        openSummary: { _ in }, replay: { _ in }, newRetrospective: {}
    )
}

#Preview("Vazio") {
    RetrospectivesView(
        viewModel: RetrospectivesViewModel(store: PreviewRetrospectiveStore([])),
        openSummary: { _ in }, replay: { _ in }, newRetrospective: {}
    )
}

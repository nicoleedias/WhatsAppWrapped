//
//  StoreKitPurchases.swift
//  WhatsAppWrapped
//
//  Compra da retrospectiva completa pelo StoreKit 2, com um produto consumível. Sem servidor:
//  a transação fica "não finalizada" (o crédito) até a retrospectiva ficar pronta, e só então é finalizada.
//  No simulador, as compras vêm do Rebobina.storekit e não cobram nada.
//

import Foundation
import Observation
import os
import StoreKit

@Observable
final class StoreKitPurchases: RetrospectivePurchases {
    /// Precisa ser igual ao ID do produto no App Store Connect e no Rebobina.storekit.
    static let productID = "nicole.Rebobina.app.retrospectiva"

    enum PurchaseError: LocalizedError {
        case productUnavailable
        case unverified

        var errorDescription: String? {
            switch self {
            case .productUnavailable: "Não conseguimos falar com a App Store. Tente de novo em instantes."
            case .unverified: "A App Store não confirmou a compra. Se foi cobrado, abra a conversa de novo."
            }
        }
    }

    private(set) var product: Product?
    /// Compras pagas e verificadas que ainda não viraram retrospectiva.
    private var credits: [Transaction] = []

    @ObservationIgnored private var updatesTask: Task<Void, Never>?
    private static let logger = Logger(subsystem: "WhatsAppWrapped", category: "Purchases")

    init() {
        // Compras que terminam fora da folha de pagamento: aprovadas depois (Ask to Buy),
        // feitas em outro aparelho ou interrompidas quando o app fechou.
        updatesTask = Task { [weak self] in
            for await update in Transaction.updates {
                self?.handle(update)
            }
        }
    }

    var displayPrice: String? { product?.displayPrice }
    var hasCredit: Bool { !credits.isEmpty }

    func prepare() async {
        if product == nil { product = try? await loadProduct() }
        for await result in Transaction.unfinished { handle(result) }
    }

    func purchase() async throws -> PurchaseOutcome {
        let product: Product
        if let loaded = self.product {
            product = loaded
        } else {
            product = try await loadProduct()
            self.product = product
        }
        switch try await product.purchase() {
        case .success(.verified(let transaction)):
            add(transaction)
            return .purchased
        case .success(.unverified(_, let error)):
            Self.logger.error("Compra não verificada: \(error)")
            throw PurchaseError.unverified
        case .pending:
            return .pending
        case .userCancelled:
            return .cancelled
        @unknown default:
            return .cancelled
        }
    }

    func consumeCredit() async {
        guard !credits.isEmpty else { return }
        await credits.removeFirst().finish()
    }

    private func loadProduct() async throws -> Product {
        guard let product = try await Product.products(for: [Self.productID]).first else {
            throw PurchaseError.productUnavailable
        }
        return product
    }

    private func handle(_ result: VerificationResult<Transaction>) {
        guard case .verified(let transaction) = result, transaction.productID == Self.productID else { return }
        // Reembolsada: deixa de valer como crédito.
        if transaction.revocationDate != nil {
            credits.removeAll { $0.id == transaction.id }
            Task { await transaction.finish() }
            return
        }
        add(transaction)
    }

    private func add(_ transaction: Transaction) {
        guard !credits.contains(where: { $0.id == transaction.id }) else { return }
        credits.append(transaction)
    }
}

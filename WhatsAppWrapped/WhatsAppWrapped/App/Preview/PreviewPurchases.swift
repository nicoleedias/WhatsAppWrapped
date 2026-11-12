//
//  PreviewPurchases.swift
//  WhatsAppWrapped
//
//  Compras e retrospectiva grátis de mentira para os previews: nada fala com a App Store nem com o Keychain.
//

import Foundation

final class PreviewPurchases: RetrospectivePurchases {
    var displayPrice: String? = "R$ 5,90"
    var hasCredit = false

    func prepare() async {}

    func purchase() async throws -> PurchaseOutcome {
        hasCredit = true
        return .purchased
    }

    func consumeCredit() async {
        hasCredit = false
    }
}

final class PreviewFreeTrial: FreeTrial {
    var isAvailable = true

    func markUsed() {
        isAvailable = false
    }
}

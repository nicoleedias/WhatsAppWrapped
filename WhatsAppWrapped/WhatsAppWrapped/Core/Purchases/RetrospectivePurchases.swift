//
//  RetrospectivePurchases.swift
//  WhatsAppWrapped
//
//  Contratos do modelo pago: a compra de uma retrospectiva completa (12 meses) e a retrospectiva grátis
//  de 30 dias. A Core só conhece estes protocolos; StoreKit e Keychain ficam em Infrastructure.
//

import Foundation

/// Como terminou a folha de pagamento da App Store.
enum PurchaseOutcome: Equatable {
    case purchased
    case cancelled
    /// Esperando aprovação (Ask to Buy, por exemplo). Quando aprovada, vira crédito.
    case pending
}

/// Compra de retrospectivas completas. Cada compra é um crédito que só é consumido depois que
/// a retrospectiva fica pronta: se a IA falhar ou o app fechar no meio, o crédito continua guardado.
protocol RetrospectivePurchases: AnyObject {
    /// Preço formatado pela App Store, como "R$ 5,90". nil enquanto o produto não carregou.
    var displayPrice: String? { get }
    /// Há uma compra paga que ainda não virou retrospectiva.
    var hasCredit: Bool { get }
    /// Carrega o produto e as compras pagas ainda não usadas.
    func prepare() async
    func purchase() async throws -> PurchaseOutcome
    /// Chamado quando a retrospectiva paga ficou pronta.
    func consumeCredit() async
}

/// A retrospectiva grátis de 30 dias, uma por aparelho.
protocol FreeTrial: AnyObject {
    var isAvailable: Bool { get }
    func markUsed()
}

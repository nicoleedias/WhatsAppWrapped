//
//  KeychainFreeTrial.swift
//  WhatsAppWrapped
//
//  Marca no Keychain que a retrospectiva grátis já foi usada. O Keychain continua lá quando o app
//  é apagado e instalado de novo, então reinstalar não dá outra retrospectiva grátis.
//

import Foundation
import Security

final class KeychainFreeTrial: FreeTrial {
    private static let service = "nicole.Rebobina.app"
    private static let account = "freeTrialUsed"

    var isAvailable: Bool {
        var query = Self.baseQuery
        query[kSecReturnData as String] = false
        return SecItemCopyMatching(query as CFDictionary, nil) == errSecItemNotFound
    }

    func markUsed() {
        guard isAvailable else { return }
        var item = Self.baseQuery
        item[kSecValueData as String] = Data([1])
        item[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlock
        SecItemAdd(item as CFDictionary, nil)
    }

    #if DEBUG
    /// Para testar de novo a retrospectiva grátis: rode com o argumento `-resetFreeTrial` (Edit Scheme → Arguments).
    func reset() {
        SecItemDelete(Self.baseQuery as CFDictionary)
    }
    #endif

    private static var baseQuery: [String: Any] {
        [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
        ]
    }
}

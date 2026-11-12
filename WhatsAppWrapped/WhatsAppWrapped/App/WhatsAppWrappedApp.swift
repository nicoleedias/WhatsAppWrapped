//
//  WhatsAppWrappedApp.swift
//  WhatsAppWrapped
//
//  Created by Nicole Dias on 07/10/26.
//
//  Ponto de entrada: configura o Firebase e o App Check e monta o app com o gerador de frases do Gemini,
//  as compras do StoreKit e a retrospectiva grátis guardada no Keychain.
//

import FirebaseCore
import FirebaseAppCheck
import SwiftUI

@main
struct WhatsAppWrappedApp: App {
    @State private var coordinator: AppCoordinator

    init() {
        AppCheck.setAppCheckProviderFactory(WrappedAppCheckProviderFactory())
        FirebaseApp.configure()

        let freeTrial = KeychainFreeTrial()
        #if DEBUG
        if CommandLine.arguments.contains("-resetFreeTrial") { freeTrial.reset() }
        #endif
        // Criado na abertura para já ouvir as compras que terminaram fora do app (Ask to Buy, app fechado no meio).
        let purchases = StoreKitPurchases()
        _coordinator = State(initialValue: AppCoordinator(
            phraseGenerator: GeminiPhraseGenerator(),
            store: FileRetrospectiveStore(),
            purchases: purchases,
            freeTrial: freeTrial
        ))
        Task { await purchases.prepare() }
    }

    var body: some Scene {
        WindowGroup {
            ContentView(coordinator: coordinator)
        }
    }
}

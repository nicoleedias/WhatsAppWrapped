//
//  WhatsAppWrappedApp.swift
//  WhatsAppWrapped
//
//  Created by Nicole Dias on 07/10/26.
//
//  Ponto de entrada: configura o Firebase e o App Check e monta o app com o gerador de frases do Gemini.
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
        _coordinator = State(initialValue: AppCoordinator(
            phraseGenerator: GeminiPhraseGenerator(),
            store: FileRetrospectiveStore()
        ))
    }

    var body: some Scene {
        WindowGroup {
            ContentView(coordinator: coordinator)
        }
    }
}

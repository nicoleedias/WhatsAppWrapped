//
//  WrappedAppCheckProviderFactory.swift
//  WhatsAppWrapped
//
//  App Check: prova ao Firebase que as chamadas vêm do app (token de depuração no Xcode, App Attest na loja).
//

import FirebaseAppCheck
import FirebaseCore

/// Prova ao Firebase que as chamadas ao Gemini vêm do app de verdade.
/// Rodando pelo Xcode usa o token de depuração (registre-o no console do Firebase);
/// na App Store e no TestFlight usa o App Attest.
nonisolated final class WrappedAppCheckProviderFactory: NSObject, AppCheckProviderFactory {
    func createProvider(with app: FirebaseApp) -> (any AppCheckProvider)? {
        #if DEBUG
        AppCheckDebugProvider(app: app)
        #else
        AppAttestProvider(app: app)
        #endif
    }
}

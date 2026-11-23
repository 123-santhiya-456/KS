//
//  AuthViewModel.swift
//  WorkoutLog
//
//  Business logic for authentication:
//   1. If Face ID (or Touch ID) is available the app starts `locked` and asks
//      for biometric authentication.
//   2. If biometrics are not supported the app shows a local login screen
//      (username + password). On the very first launch the user creates the
//      account, afterwards they sign in with it.
//

import Foundation
import Combine

enum AuthState: Equatable {
    /// Waiting for Face ID.
    case locked
    /// Face ID unavailable: show username / password.
    case needsLogin
    /// Access granted.
    case authenticated
}

enum LoginMode: Equatable {
    case signIn
    case createAccount
}

final class AuthViewModel: ObservableObject {

    // MARK: Published state
    @Published private(set) var state: AuthState
    @Published private(set) var mode: LoginMode
    @Published var username = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published private(set) var errorMessage: String?
    @Published private(set) var biometricMessage: String?
    @Published private(set) var isAuthenticating = false

    // MARK: Dependencies
    let biometricKind: BiometricKind
    private let biometricService: BiometricAuthService
    private let credentialService: CredentialService

    init(biometricService: BiometricAuthService = BiometricAuthService(),
         credentialService: CredentialService = CredentialService()) {
        self.biometricService = biometricService
        self.credentialService = credentialService

        let kind = biometricService.availableKind()
        self.biometricKind = kind
        self.state = (kind == .unavailable) ? .needsLogin : .locked
        self.mode = credentialService.hasAccount ? .signIn : .createAccount
    }

    // MARK: Display helpers

    /// "Face ID", "Touch ID" or "Passcode".
    var biometricName: String {
        switch biometricKind {
        case .faceID: return "Face ID"
        case .touchID: return "Touch ID"
        case .unavailable: return "Passcode"
        }
    }

    /// SF Symbol matching the biometric type.
    var biometricIconName: String {
        switch biometricKind {
        case .faceID: return "faceid"
        case .touchID: return "touchid"
        case .unavailable: return "lock.fill"
        }
    }

    // MARK: Biometrics

    /// Shows the Face ID prompt.
    func startBiometricAuth() {
        guard state == .locked, !isAuthenticating else { return }
        isAuthenticating = true
        biometricMessage = nil

        biometricService.authenticate(reason: "Unlock your training log") { [weak self] result in
            guard let self = self else { return }
            self.isAuthenticating = false
            switch result {
            case .success:
                self.state = .authenticated
            case .failure(let error):
                self.handleBiometricFailure(error)
            }
        }
    }

    private func handleBiometricFailure(_ error: BiometricError) {
        switch error {
        case .notAvailable:
            // Face ID stopped being available (e.g. disabled in Settings): use local login.
            state = .needsLogin
        case .cancelled:
            biometricMessage = "Authentication was cancelled. Tap the button to try again."
        case .failed:
            biometricMessage = "We couldn't verify you. Please try again."
        }
    }

    // MARK: Local login

    /// Validates the entered credentials (sign in) or creates the account.
    func submitCredentials() {
        errorMessage = nil
        let name = username.trimmed

        switch mode {
        case .createAccount:
            guard name.count >= 3 else {
                errorMessage = "Username must be at least 3 characters."
                return
            }
            guard password.count >= 6 else {
                errorMessage = "Password must be at least 6 characters."
                return
            }
            guard password == confirmPassword else {
                errorMessage = "Passwords do not match."
                return
            }
            credentialService.register(username: name, password: password)
            completeLogin()

        case .signIn:
            guard !name.isEmpty, !password.isEmpty else {
                errorMessage = "Enter your username and password."
                return
            }
            if credentialService.validate(username: name, password: password) {
                completeLogin()
            } else {
                errorMessage = "Incorrect username or password."
            }
        }
    }

    private func completeLogin() {
        clearFields()
        mode = .signIn
        state = .authenticated
    }

    // MARK: Locking

    /// Locks the app again (called when it goes to the background or the user taps lock).
    func lock() {
        guard state == .authenticated else { return }
        clearFields()
        biometricMessage = nil
        state = (biometricKind == .unavailable) ? .needsLogin : .locked
    }

    private func clearFields() {
        username = ""
        password = ""
        confirmPassword = ""
        errorMessage = nil
    }
}

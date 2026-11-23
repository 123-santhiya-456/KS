//
//  CredentialService.swift
//  WorkoutLog
//
//  Local username / password storage used as the fallback when Face ID
//  is not supported. The password is never stored in plain text: only a
//  salted SHA-256 hash is saved.
//

import Foundation
import CryptoKit

final class CredentialService {
    private let defaults: UserDefaults
    private let usernameKey = "auth.username"
    private let hashKey = "auth.passwordHash"
    private let saltKey = "auth.passwordSalt"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    /// `true` once a local account has been created on this device.
    var hasAccount: Bool {
        defaults.string(forKey: usernameKey) != nil
    }

    /// Creates (or replaces) the local account.
    func register(username: String, password: String) {
        let salt = UUID().uuidString
        defaults.set(username.lowercased(), forKey: usernameKey)
        defaults.set(salt, forKey: saltKey)
        defaults.set(hash(password: password, salt: salt), forKey: hashKey)
    }

    /// Checks the supplied credentials against the stored account.
    func validate(username: String, password: String) -> Bool {
        guard let storedName = defaults.string(forKey: usernameKey),
              let storedHash = defaults.string(forKey: hashKey),
              let salt = defaults.string(forKey: saltKey) else {
            return false
        }
        return storedName == username.lowercased()
            && storedHash == hash(password: password, salt: salt)
    }

    private func hash(password: String, salt: String) -> String {
        let digest = SHA256.hash(data: Data((salt + password).utf8))
        return digest.map { String(format: "%02x", $0) }.joined()
    }
}

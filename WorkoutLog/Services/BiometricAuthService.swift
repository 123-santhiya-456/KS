//
//  BiometricAuthService.swift
//  WorkoutLog
//
//  Wraps LocalAuthentication (Face ID / Touch ID).
//

import Foundation
import LocalAuthentication

/// The biometric sensor available on the current device.
enum BiometricKind: Equatable {
    case faceID
    case touchID
    case unavailable
}

/// Reasons a biometric check can fail.
enum BiometricError: Error {
    /// Biometrics are not supported or not enrolled on this device.
    case notAvailable
    /// The user (or system) cancelled the prompt.
    case cancelled
    /// The check ran but the user could not be verified.
    case failed
}

/// Thin service around `LAContext` so view models never touch LocalAuthentication directly.
final class BiometricAuthService {

    /// Returns which biometric sensor can currently be used.
    func availableKind() -> BiometricKind {
        let context = LAContext()
        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return .unavailable
        }
        switch context.biometryType {
        case .faceID:
            return .faceID
        case .touchID:
            return .touchID
        default:
            return .unavailable
        }
    }

    /// Shows the system Face ID prompt. If Face ID fails repeatedly iOS offers
    /// the device passcode, so the user is never locked out of their own phone.
    /// The completion handler is always called on the main queue.
    func authenticate(reason: String, completion: @escaping (Result<Void, BiometricError>) -> Void) {
        let context = LAContext()
        var error: NSError?

        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            DispatchQueue.main.async { completion(.failure(.notAvailable)) }
            return
        }

        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, evaluationError in
            DispatchQueue.main.async {
                if success {
                    completion(.success(()))
                    return
                }
                if let laError = evaluationError as? LAError {
                    switch laError.code {
                    case .userCancel, .appCancel, .systemCancel, .userFallback:
                        completion(.failure(.cancelled))
                    default:
                        completion(.failure(.failed))
                    }
                } else {
                    completion(.failure(.failed))
                }
            }
        }
    }
}

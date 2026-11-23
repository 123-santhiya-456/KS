//
//  RootView.swift
//  WorkoutLog
//
//  Decides which top-level screen to show based on the authentication state:
//  Face ID lock screen -> (fallback) local login -> main app.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject private var auth: AuthViewModel
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        ZStack {
            switch auth.state {
            case .authenticated:
                MainTabView()
                    .transition(.opacity)
            case .locked:
                LockView()
                    .transition(.opacity)
            case .needsLogin:
                LoginView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: auth.state)
        .onChange(of: scenePhase) { _, newPhase in
            switch newPhase {
            case .background:
                // Re-lock whenever the app leaves the foreground.
                auth.lock()
            case .active:
                // Prompt again when the user comes back to the lock screen.
                if auth.state == .locked {
                    auth.startBiometricAuth()
                }
            default:
                break
            }
        }
    }
}

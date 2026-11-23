//
//  LockView.swift
//  WorkoutLog
//
//  Launch screen shown while Face ID authentication is pending.
//

import SwiftUI

struct LockView: View {
    @EnvironmentObject private var auth: AuthViewModel
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        ZStack {
            AppBackground()

            VStack(spacing: 24) {
                Spacer()

                AppLogoView(size: 124)

                VStack(spacing: 8) {
                    Text("Workout Log")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.white)
                    Text("Your private training journal")
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.secondaryText)
                }

                Spacer()

                VStack(spacing: 14) {
                    if let message = auth.biometricMessage {
                        Text(message)
                            .font(.footnote)
                            .foregroundStyle(AppTheme.secondaryText)
                            .multilineTextAlignment(.center)
                    }

                    Button {
                        auth.startBiometricAuth()
                    } label: {
                        Label("Unlock with \(auth.biometricName)", systemImage: auth.biometricIconName)
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled(auth.isAuthenticating)
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 40)
            }
        }
        .task {
            // Small delay so the screen is visible before the system prompt appears.
            try? await Task.sleep(nanoseconds: 500_000_000)
            if scenePhase == .active {
                auth.startBiometricAuth()
            }
        }
    }
}

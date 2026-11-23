//
//  LoginView.swift
//  WorkoutLog
//
//  Local username / password screen used when Face ID is not supported.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var auth: AuthViewModel

    private var isCreating: Bool { auth.mode == .createAccount }

    var body: some View {
        ZStack {
            AppBackground()

            ScrollView {
                VStack(spacing: 24) {
                    AppLogoView(size: 100)
                        .padding(.top, 56)

                    VStack(spacing: 6) {
                        Text(isCreating ? "Create your account" : "Welcome back")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.white)
                        Text(isCreating
                             ? "Face ID isn't available, so set up a local login to protect your log."
                             : "Sign in to open your training log.")
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.secondaryText)
                            .multilineTextAlignment(.center)
                    }

                    VStack(spacing: 14) {
                        TextField("Username", text: $auth.username)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .inputFieldStyle()

                        SecureField("Password", text: $auth.password)
                            .inputFieldStyle()

                        if isCreating {
                            SecureField("Confirm password", text: $auth.confirmPassword)
                                .inputFieldStyle()
                        }
                    }

                    if let error = auth.errorMessage {
                        Label(error, systemImage: "exclamationmark.triangle.fill")
                            .font(.footnote)
                            .foregroundStyle(AppTheme.danger)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    Button {
                        auth.submitCredentials()
                    } label: {
                        Text(isCreating ? "Create Account" : "Sign In")
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 40)
            }
            .scrollDismissesKeyboard(.interactively)
        }
    }
}

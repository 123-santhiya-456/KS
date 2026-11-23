//
//  EmptyStateView.swift
//  WorkoutLog
//

import SwiftUI

/// Friendly placeholder shown when a list has nothing to display.
struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    var actionTitle: String?
    var action: (() -> Void)?

    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 44, weight: .semibold))
                .foregroundStyle(AppTheme.accentGradient)
                .padding(.bottom, 4)

            Text(title)
                .font(.system(.title3, design: .rounded, weight: .bold))
                .foregroundStyle(Color.white)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(AppTheme.secondaryText)
                .multilineTextAlignment(.center)

            if let actionTitle = actionTitle, let action = action {
                Button(action: action) {
                    Text(actionTitle)
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.top, 8)
                .frame(maxWidth: 240)
            }
        }
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

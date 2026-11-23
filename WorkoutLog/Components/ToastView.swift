//
//  ToastView.swift
//  WorkoutLog
//

import SwiftUI

/// Short confirmation banner shown at the top of the screen (e.g. "Workout saved").
struct ToastView: View {
    let message: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(Color.green)
            Text(message)
                .font(.system(.subheadline, design: .rounded, weight: .semibold))
                .foregroundStyle(Color.white)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial, in: Capsule())
        .overlay(Capsule().strokeBorder(AppTheme.cardStroke, lineWidth: 1))
        .shadow(color: Color.black.opacity(0.3), radius: 10, y: 4)
    }
}

//
//  FilterChip.swift
//  WorkoutLog
//

import SwiftUI

/// Tappable capsule used for muscle-group filters and exercise suggestions.
struct FilterChip: View {
    let title: String
    var icon: String?
    var isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if let icon = icon {
                    Image(systemName: icon)
                }
                Text(title)
            }
            .font(.system(.subheadline, design: .rounded, weight: .semibold))
            .foregroundStyle(isSelected ? Color.white : AppTheme.secondaryText)
            .padding(.horizontal, 14)
            .padding(.vertical, 9)
            .background {
                if isSelected {
                    Capsule().fill(AppTheme.accentGradient)
                } else {
                    Capsule().fill(Color.white.opacity(0.08))
                }
            }
            .overlay(Capsule().strokeBorder(isSelected ? Color.clear : AppTheme.cardStroke, lineWidth: 1))
        }
        .buttonStyle(.plain)
    }
}

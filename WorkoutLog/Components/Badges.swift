//
//  Badges.swift
//  WorkoutLog
//

import SwiftUI

/// Small gold "PB" pill shown on personal-best workouts.
struct PersonalBestBadge: View {
    var body: some View {
        Label("PB", systemImage: "trophy.fill")
            .font(.system(size: 11, weight: .heavy, design: .rounded))
            .foregroundStyle(Color.black.opacity(0.85))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(AppTheme.goldGradient, in: Capsule())
    }
}

/// Coloured pill showing the muscle group with its icon.
struct MuscleGroupBadge: View {
    let group: MuscleGroup

    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: group.iconName)
            Text(group.rawValue)
        }
        .font(.caption.weight(.semibold))
        .foregroundStyle(group.color)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(group.color.opacity(0.18), in: Capsule())
    }
}

//
//  WorkoutRowView.swift
//  WorkoutLog
//
//  Card used for one workout in the list and on the dashboard.
//

import SwiftUI

struct WorkoutRowView: View {
    let workout: Workout
    let isPersonalBest: Bool

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: workout.muscleGroup.iconName)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color.white)
                .frame(width: 48, height: 48)
                .background(workout.muscleGroup.gradient, in: RoundedRectangle(cornerRadius: 14, style: .continuous))

            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 8) {
                    Text(workout.exerciseName)
                        .font(.system(.headline, design: .rounded))
                        .foregroundStyle(Color.white)
                        .lineLimit(1)

                    if isPersonalBest {
                        PersonalBestBadge()
                    }
                }

                Text("\(workout.muscleGroup.rawValue) · \(workout.date.shortDateText)")
                    .font(.caption)
                    .foregroundStyle(AppTheme.secondaryText)
            }

            Spacer(minLength: 8)

            VStack(alignment: .trailing, spacing: 5) {
                Text(workout.setsAndRepsText)
                    .font(.system(.headline, design: .rounded))
                    .foregroundStyle(Color.white)
                Text(workout.weight.weightText)
                    .font(.caption)
                    .foregroundStyle(AppTheme.secondaryText)
            }
        }
        .padding(14)
        .background(AppTheme.cardFill, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(isPersonalBest ? AppTheme.gold.opacity(0.45) : AppTheme.cardStroke, lineWidth: 1)
        )
        .contentShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

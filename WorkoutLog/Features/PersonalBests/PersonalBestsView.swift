//
//  PersonalBestsView.swift
//  WorkoutLog
//
//  "Records" tab: all personal bests together so the user can follow their
//  strength progress.
//

import SwiftUI

struct PersonalBestsView: View {
    @StateObject private var viewModel: PersonalBestsViewModel
    @EnvironmentObject private var router: AppRouter

    init(store: WorkoutStore) {
        _viewModel = StateObject(wrappedValue: PersonalBestsViewModel(store: store))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()

                if viewModel.records.isEmpty {
                    EmptyStateView(icon: "trophy.fill",
                                   title: "No personal bests yet",
                                   message: "Lift heavier than any earlier entry of the same exercise and it will appear here.",
                                   actionTitle: "Log a workout") {
                        router.selectedTab = .log
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            summaryCard

                            VStack(alignment: .leading, spacing: 12) {
                                Text("Progress timeline")
                                    .font(.system(.headline, design: .rounded))
                                    .foregroundStyle(Color.white)

                                ForEach(viewModel.records) { record in
                                    NavigationLink {
                                        WorkoutDetailView(workoutID: record.workout.id)
                                    } label: {
                                        PersonalBestCard(record: record)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                        .padding(.bottom, 24)
                    }
                }
            }
            .navigationTitle("Personal Bests")
        }
    }

    private var summaryCard: some View {
        HStack(spacing: 0) {
            summaryItem(value: "\(viewModel.totalRecords)", title: "Records")
            summaryDivider
            summaryItem(value: "\(viewModel.exerciseCount)", title: "Exercises")
            summaryDivider
            summaryItem(value: viewModel.heaviestLift?.weightText ?? "—", title: "Heaviest")
        }
        .padding(.vertical, 18)
        .background(AppTheme.goldGradient, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: AppTheme.gold.opacity(0.3), radius: 14, y: 8)
    }

    private func summaryItem(value: String, title: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(.title2, design: .rounded, weight: .heavy))
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Text(title)
                .font(.caption.weight(.medium))
        }
        .foregroundStyle(Color.black.opacity(0.85))
        .frame(maxWidth: .infinity)
    }

    private var summaryDivider: some View {
        Rectangle()
            .fill(Color.black.opacity(0.2))
            .frame(width: 1, height: 36)
    }
}

/// One record in the personal-best timeline.
private struct PersonalBestCard: View {
    let record: PersonalBestRecord

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: "trophy.fill")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color.black.opacity(0.8))
                .frame(width: 46, height: 46)
                .background(AppTheme.goldGradient, in: Circle())

            VStack(alignment: .leading, spacing: 5) {
                Text(record.workout.exerciseName)
                    .font(.system(.headline, design: .rounded))
                    .foregroundStyle(Color.white)
                    .lineLimit(1)

                Text("\(record.previousBest.weightText) → \(record.workout.weight.weightText)")
                    .font(.caption)
                    .foregroundStyle(AppTheme.secondaryText)

                Text(record.workout.date.shortDateText)
                    .font(.caption2)
                    .foregroundStyle(AppTheme.secondaryText)
            }

            Spacer(minLength: 8)

            Text("+\(record.improvement.weightText)")
                .font(.system(.subheadline, design: .rounded, weight: .bold))
                .foregroundStyle(AppTheme.gold)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(AppTheme.gold.opacity(0.15), in: Capsule())
        }
        .padding(14)
        .background(AppTheme.cardFill, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(AppTheme.gold.opacity(0.35), lineWidth: 1)
        )
        .contentShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

//
//  DashboardView.swift
//  WorkoutLog
//
//  Home screen: greeting, key statistics, weekly activity and recent workouts.
//

import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel: DashboardViewModel
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var auth: AuthViewModel

    init(store: WorkoutStore) {
        _viewModel = StateObject(wrappedValue: DashboardViewModel(store: store))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()

                ScrollView {
                    VStack(spacing: 22) {
                        heroCard
                        statsGrid
                        weeklyActivityCard
                        recentSection
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 24)
                }
            }
            .navigationTitle("Dashboard")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        auth.lock()
                    } label: {
                        Image(systemName: "lock.fill")
                    }
                    .accessibilityLabel("Lock app")
                }
            }
        }
    }

    // MARK: - Sections

    private var heroCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(viewModel.greeting)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(Color.white.opacity(0.85))

            Text("Ready to crush today's session?")
                .font(.system(.title2, design: .rounded, weight: .bold))
                .foregroundStyle(Color.white)
                .fixedSize(horizontal: false, vertical: true)

            Button {
                router.selectedTab = .log
            } label: {
                Label("Log a workout", systemImage: "plus")
                    .font(.system(.subheadline, design: .rounded, weight: .bold))
                    .foregroundStyle(AppTheme.accentSecondary)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 11)
                    .background(Color.white, in: Capsule())
            }
            .padding(.top, 4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(AppTheme.accentGradient, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: AppTheme.accent.opacity(0.35), radius: 16, y: 8)
    }

    private var statsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 14), GridItem(.flexible(), spacing: 14)], spacing: 14) {
            StatTile(title: "Total workouts",
                     value: "\(viewModel.totalWorkouts)",
                     icon: "flame.fill",
                     tint: AppTheme.accent)

            StatTile(title: "This week",
                     value: "\(viewModel.workoutsThisWeek)",
                     icon: "calendar",
                     tint: Color(red: 0.36, green: 0.62, blue: 1.0))

            StatTile(title: "Most trained",
                     value: viewModel.mostTrainedGroup?.rawValue ?? "—",
                     icon: viewModel.mostTrainedGroup?.iconName ?? "figure.strengthtraining.traditional",
                     tint: viewModel.mostTrainedGroup?.color ?? AppTheme.secondaryText)

            StatTile(title: "Personal bests",
                     value: "\(viewModel.personalBestCount)",
                     icon: "trophy.fill",
                     tint: AppTheme.gold)
        }
    }

    private var weeklyActivityCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Last 7 days")
                .font(.system(.headline, design: .rounded))
                .foregroundStyle(Color.white)

            HStack(alignment: .bottom, spacing: 10) {
                ForEach(viewModel.weeklyActivity) { day in
                    VStack(spacing: 8) {
                        ZStack(alignment: .bottom) {
                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                .fill(Color.white.opacity(0.07))
                                .frame(height: 80)

                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                .fill(day.count > 0 ? AppTheme.accentGradient : LinearGradient(colors: [Color.clear], startPoint: .top, endPoint: .bottom))
                                .frame(height: barHeight(for: day.count))
                        }
                        Text(day.label)
                            .font(.caption2.weight(.semibold))
                            .foregroundStyle(AppTheme.secondaryText)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }

    private var recentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recent workouts")
                    .font(.system(.headline, design: .rounded))
                    .foregroundStyle(Color.white)
                Spacer()
                Button("See all") {
                    router.selectedTab = .workouts
                }
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(AppTheme.accent)
            }

            if viewModel.recentWorkouts.isEmpty {
                Text("No workouts yet. Tap “Log a workout” to add your first one.")
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.secondaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .cardStyle()
            } else {
                VStack(spacing: 10) {
                    ForEach(viewModel.recentWorkouts) { workout in
                        NavigationLink {
                            WorkoutDetailView(workoutID: workout.id)
                        } label: {
                            WorkoutRowView(workout: workout,
                                           isPersonalBest: viewModel.personalBestIDs.contains(workout.id))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    // MARK: - Helpers

    /// Height of a bar in the weekly chart (80 pt = the busiest day).
    private func barHeight(for count: Int) -> CGFloat {
        guard count > 0 else { return 0 }
        let ratio = CGFloat(count) / CGFloat(viewModel.maxDailyCount)
        return max(10, 80 * ratio)
    }
}

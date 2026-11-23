//
//  DashboardViewModel.swift
//  WorkoutLog
//
//  Computes the statistics shown on the home screen. It subscribes to the
//  store so the numbers update the moment a workout is added, edited or deleted.
//

import Foundation
import Combine

/// Number of workouts logged on one day (used by the weekly activity chart).
struct DayActivity: Identifiable {
    let date: Date
    let label: String
    let count: Int
    var id: Date { date }
}

final class DashboardViewModel: ObservableObject {

    @Published private(set) var totalWorkouts = 0
    @Published private(set) var workoutsThisWeek = 0
    @Published private(set) var mostTrainedGroup: MuscleGroup?
    @Published private(set) var recentWorkouts: [Workout] = []
    @Published private(set) var personalBestIDs: Set<UUID> = []
    @Published private(set) var personalBestCount = 0
    @Published private(set) var weeklyActivity: [DayActivity] = []

    private var cancellables = Set<AnyCancellable>()
    private let calendar = Calendar.current

    init(store: WorkoutStore) {
        store.$workouts
            .sink { [weak self] workouts in
                self?.refresh(with: workouts)
            }
            .store(in: &cancellables)
    }

    // MARK: Display helpers

    /// "Good morning" / "Good afternoon" / "Good evening".
    var greeting: String {
        let hour = calendar.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good morning"
        case 12..<17: return "Good afternoon"
        default: return "Good evening"
        }
    }

    /// The largest value in the weekly chart (never below 1 to avoid dividing by zero).
    var maxDailyCount: Int {
        max(weeklyActivity.map { $0.count }.max() ?? 1, 1)
    }

    // MARK: Calculation

    private func refresh(with workouts: [Workout]) {
        totalWorkouts = workouts.count
        workoutsThisWeek = countThisWeek(in: workouts)
        mostTrainedGroup = mostFrequentGroup(in: workouts)
        recentWorkouts = Array(workouts.sorted(by: Workout.isNewer).prefix(5))

        let records = PersonalBestCalculator.records(from: workouts)
        personalBestIDs = Set(records.map { $0.id })
        personalBestCount = records.count

        weeklyActivity = buildWeeklyActivity(from: workouts)
    }

    private func countThisWeek(in workouts: [Workout]) -> Int {
        guard let week = calendar.dateInterval(of: .weekOfYear, for: Date()) else { return 0 }
        return workouts.filter { week.contains($0.date) }.count
    }

    private func mostFrequentGroup(in workouts: [Workout]) -> MuscleGroup? {
        let counts = Dictionary(grouping: workouts, by: { $0.muscleGroup }).mapValues { $0.count }
        let best = counts.max { lhs, rhs in
            if lhs.value != rhs.value { return lhs.value < rhs.value }
            return lhs.key.rawValue > rhs.key.rawValue
        }
        return best?.key
    }

    /// Workout counts for the last seven days, oldest first.
    private func buildWeeklyActivity(from workouts: [Workout]) -> [DayActivity] {
        let today = calendar.startOfDay(for: Date())
        var result: [DayActivity] = []

        for offset in stride(from: 6, through: 0, by: -1) {
            guard let day = calendar.date(byAdding: .day, value: -offset, to: today) else { continue }
            let count = workouts.filter { calendar.isDate($0.date, inSameDayAs: day) }.count
            result.append(DayActivity(date: day, label: day.narrowWeekdayText, count: count))
        }
        return result
    }
}

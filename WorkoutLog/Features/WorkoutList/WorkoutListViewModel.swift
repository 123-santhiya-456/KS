//
//  WorkoutListViewModel.swift
//  WorkoutLog
//
//  Drives the workout list: search text, muscle-group filter, and delete.
//

import Foundation
import Combine

final class WorkoutListViewModel: ObservableObject {

    @Published var searchText = ""
    @Published var selectedGroup: MuscleGroup?
    @Published private(set) var workouts: [Workout] = []
    @Published private(set) var personalBestIDs: Set<UUID> = []

    private let store: WorkoutStore
    private var cancellables = Set<AnyCancellable>()

    init(store: WorkoutStore) {
        self.store = store

        store.$workouts
            .sink { [weak self] workouts in
                self?.workouts = workouts
            }
            .store(in: &cancellables)

        store.$personalBestIDs
            .sink { [weak self] ids in
                self?.personalBestIDs = ids
            }
            .store(in: &cancellables)
    }

    /// Workouts after applying the search text and muscle-group filter, newest first.
    var filteredWorkouts: [Workout] {
        let query = searchText.trimmed.lowercased()

        return workouts
            .filter { workout in
                if let group = selectedGroup, workout.muscleGroup != group { return false }
                if query.isEmpty { return true }
                return workout.exerciseName.lowercased().contains(query)
            }
            .sorted(by: Workout.isNewer)
    }

    /// `true` when a search or filter is active (used to pick the right empty-state text).
    var isFiltering: Bool {
        !searchText.trimmed.isEmpty || selectedGroup != nil
    }

    func isPersonalBest(_ workout: Workout) -> Bool {
        personalBestIDs.contains(workout.id)
    }

    /// Tapping the selected chip again clears the filter.
    func toggleGroup(_ group: MuscleGroup) {
        selectedGroup = (selectedGroup == group) ? nil : group
    }

    func clearFilters() {
        searchText = ""
        selectedGroup = nil
    }

    func delete(_ workout: Workout) {
        store.delete(id: workout.id)
    }
}

//
//  WorkoutStore.swift
//  WorkoutLog
//
//  The single source of truth for workout data. All screens read from and write to
//  this store, which is how a newly logged / edited / deleted workout shows up
//  immediately everywhere (list, dashboard, personal bests).
//

import Foundation
import Combine

final class WorkoutStore: ObservableObject {

    /// All workouts, newest first.
    @Published private(set) var workouts: [Workout] = []
    /// Every workout that is a personal best, newest first.
    @Published private(set) var personalBestRecords: [PersonalBestRecord] = []
    /// Quick lookup of personal-best workout ids.
    @Published private(set) var personalBestIDs: Set<UUID> = []
    /// Set when saving or loading fails so the UI can tell the user.
    @Published var errorMessage: String?

    private let storage: WorkoutStoring

    init(storage: WorkoutStoring = JSONWorkoutStorage()) {
        self.storage = storage

        var initial: [Workout] = []
        if storage.hasStoredData {
            do {
                initial = try storage.load()
            } catch {
                errorMessage = "Your saved workouts could not be read."
            }
        } else {
            // First launch: seed demo data so the app is not empty.
            initial = SampleData.workouts()
            try? storage.save(initial)
        }
        publish(initial)
    }

    // MARK: - CRUD

    /// Adds a new workout.
    func add(_ workout: Workout) {
        apply(workouts + [workout])
    }

    /// Replaces an existing workout (matched by id).
    func update(_ workout: Workout) {
        guard let index = workouts.firstIndex(where: { $0.id == workout.id }) else { return }
        var updated = workouts
        updated[index] = workout
        apply(updated)
    }

    /// Removes a workout.
    func delete(id: UUID) {
        apply(workouts.filter { $0.id != id })
    }

    // MARK: - Queries

    func workout(withID id: UUID) -> Workout? {
        workouts.first { $0.id == id }
    }

    func personalBestRecord(for id: UUID) -> PersonalBestRecord? {
        personalBestRecords.first { $0.id == id }
    }

    func isPersonalBest(_ workout: Workout) -> Bool {
        personalBestIDs.contains(workout.id)
    }

    // MARK: - Private helpers

    /// Updates published values and persists them.
    private func apply(_ newWorkouts: [Workout]) {
        publish(newWorkouts)
        persist()
    }

    /// Sorts the list and recomputes personal bests.
    private func publish(_ newWorkouts: [Workout]) {
        workouts = newWorkouts.sorted(by: Workout.isNewer)
        personalBestRecords = PersonalBestCalculator.records(from: workouts)
        personalBestIDs = Set(personalBestRecords.map { $0.id })
    }

    private func persist() {
        do {
            try storage.save(workouts)
        } catch {
            errorMessage = "Your changes could not be saved."
        }
    }
}

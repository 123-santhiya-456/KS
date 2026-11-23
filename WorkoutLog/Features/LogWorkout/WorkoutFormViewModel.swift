//
//  WorkoutFormViewModel.swift
//  WorkoutLog
//
//  Shared form logic for both "Log Workout" (new entry) and "Edit Workout"
//  (existing entry): field state, validation and building the final model.
//

import Foundation
import Combine

final class WorkoutFormViewModel: ObservableObject {

    // MARK: Form fields
    @Published var exerciseName = ""
    @Published var muscleGroup: MuscleGroup = .chest
    @Published var sets = 3
    @Published var reps = 10
    /// Text typed by the user, parsed by `parsedWeight`.
    @Published var weightText = ""
    @Published var date = Date()
    @Published var notes = ""

    /// Allowed ranges for the steppers.
    let setsRange = 1...20
    let repsRange = 1...100

    /// The workout being edited, or `nil` when logging a new one.
    private let editingWorkout: Workout?

    init(workout: Workout? = nil) {
        self.editingWorkout = workout
        if let workout = workout {
            load(from: workout)
        }
    }

    // MARK: State

    var isEditing: Bool { editingWorkout != nil }

    /// Quick-pick exercise names for the selected muscle group.
    var suggestions: [String] {
        ExerciseCatalog.suggestions(for: muscleGroup)
    }

    /// The weight as a number, or `nil` when empty / invalid.
    /// Accepts both "62.5" and "62,5".
    var parsedWeight: Double? {
        let normalised = weightText.trimmed.replacingOccurrences(of: ",", with: ".")
        guard !normalised.isEmpty, let value = Double(normalised) else { return nil }
        guard value >= 0, value <= 1000 else { return nil }
        return value
    }

    var isValid: Bool {
        !exerciseName.trimmed.isEmpty && parsedWeight != nil
    }

    /// Human-readable reason why the form cannot be saved yet.
    var validationMessage: String? {
        if exerciseName.trimmed.isEmpty {
            return "Enter an exercise name."
        }
        if parsedWeight == nil {
            return "Enter a weight between 0 and 1000 kg (use 0 for bodyweight)."
        }
        return nil
    }

    // MARK: Actions

    /// Builds the model from the current field values, or `nil` if invalid.
    func buildWorkout() -> Workout? {
        guard isValid, let weight = parsedWeight else { return nil }
        let day = Calendar.current.startOfDay(for: date)

        if var existing = editingWorkout {
            existing.exerciseName = exerciseName.trimmed
            existing.muscleGroup = muscleGroup
            existing.sets = sets
            existing.reps = reps
            existing.weight = weight
            existing.date = day
            existing.notes = notes.trimmed
            return existing
        }

        return Workout(exerciseName: exerciseName.trimmed,
                       muscleGroup: muscleGroup,
                       sets: sets,
                       reps: reps,
                       weight: weight,
                       date: day,
                       notes: notes.trimmed)
    }

    /// Clears the form after a successful save.
    func reset() {
        exerciseName = ""
        muscleGroup = .chest
        sets = 3
        reps = 10
        weightText = ""
        date = Date()
        notes = ""
    }

    // MARK: Private

    private func load(from workout: Workout) {
        exerciseName = workout.exerciseName
        muscleGroup = workout.muscleGroup
        sets = workout.sets
        reps = workout.reps
        weightText = workout.weight.truncatingRemainder(dividingBy: 1) == 0
            ? String(format: "%.0f", workout.weight)
            : String(format: "%.1f", workout.weight)
        date = workout.date
        notes = workout.notes
    }
}

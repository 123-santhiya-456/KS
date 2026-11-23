//
//  Workout.swift
//  WorkoutLog
//
//  Core data model: one logged exercise entry.
//

import Foundation

/// A single logged exercise (e.g. "Bench Press, 4 sets x 8 reps @ 70 kg").
struct Workout: Identifiable, Codable, Equatable {
    var id: UUID
    var exerciseName: String
    var muscleGroup: MuscleGroup
    var sets: Int
    var reps: Int
    /// Weight in kilograms. `0` means a bodyweight exercise.
    var weight: Double
    /// The day the exercise was performed.
    var date: Date
    var notes: String
    /// Timestamp of when the entry was created. Used as a tie-breaker when two
    /// entries share the same day.
    var createdAt: Date

    init(id: UUID = UUID(),
         exerciseName: String,
         muscleGroup: MuscleGroup,
         sets: Int,
         reps: Int,
         weight: Double,
         date: Date,
         notes: String = "",
         createdAt: Date = Date()) {
        self.id = id
        self.exerciseName = exerciseName
        self.muscleGroup = muscleGroup
        self.sets = sets
        self.reps = reps
        self.weight = weight
        self.date = date
        self.notes = notes
        self.createdAt = createdAt
    }

    // MARK: - Derived values

    /// Case-insensitive key used to decide whether two entries are the same exercise.
    var exerciseKey: String {
        exerciseName.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }

    /// Total lifted volume for the entry (sets x reps x weight).
    var totalVolume: Double {
        Double(sets * reps) * weight
    }

    /// Short "4 × 8" style text.
    var setsAndRepsText: String {
        "\(sets) × \(reps)"
    }

    // MARK: - Ordering

    /// Sort comparator: newest workout first.
    static func isNewer(_ lhs: Workout, _ rhs: Workout) -> Bool {
        if lhs.date != rhs.date { return lhs.date > rhs.date }
        return lhs.createdAt > rhs.createdAt
    }

    /// Sort comparator: oldest workout first (used for personal best calculation).
    static func isOlder(_ lhs: Workout, _ rhs: Workout) -> Bool {
        if lhs.date != rhs.date { return lhs.date < rhs.date }
        return lhs.createdAt < rhs.createdAt
    }
}

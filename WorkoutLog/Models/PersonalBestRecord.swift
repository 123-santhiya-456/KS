//
//  PersonalBestRecord.swift
//  WorkoutLog
//

import Foundation

/// Describes a workout that beat every earlier entry of the same exercise.
struct PersonalBestRecord: Identifiable, Equatable {
    /// The workout that set the record.
    let workout: Workout
    /// The heaviest weight lifted for this exercise before this entry.
    let previousBest: Double

    var id: UUID { workout.id }

    /// How many kilograms heavier this lift was compared with the previous best.
    var improvement: Double { workout.weight - previousBest }
}

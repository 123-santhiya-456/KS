//
//  MuscleGroup.swift
//  WorkoutLog
//
//  The six muscle groups an exercise can be assigned to.
//  Presentation details (icon / colour) live in Utilities/MuscleGroup+Style.swift
//  so that this model stays free of any UI framework.
//

import Foundation

/// Muscle groups used for tagging and filtering workouts.
enum MuscleGroup: String, Codable, CaseIterable, Identifiable {
    case chest = "Chest"
    case back = "Back"
    case legs = "Legs"
    case shoulders = "Shoulders"
    case arms = "Arms"
    case core = "Core"

    var id: String { rawValue }
}

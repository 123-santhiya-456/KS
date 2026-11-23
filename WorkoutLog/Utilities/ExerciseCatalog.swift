//
//  ExerciseCatalog.swift
//  WorkoutLog
//
//  Quick-pick exercise names for each muscle group, shown as chips in the
//  "Log Workout" form.
//

import Foundation

enum ExerciseCatalog {

    static func suggestions(for group: MuscleGroup) -> [String] {
        switch group {
        case .chest:
            return ["Bench Press", "Incline Dumbbell Press", "Chest Fly", "Push-Up"]
        case .back:
            return ["Deadlift", "Pull-Up", "Lat Pulldown", "Barbell Row"]
        case .legs:
            return ["Squat", "Leg Press", "Lunges", "Romanian Deadlift"]
        case .shoulders:
            return ["Overhead Press", "Lateral Raise", "Face Pull", "Arnold Press"]
        case .arms:
            return ["Barbell Curl", "Hammer Curl", "Tricep Pushdown", "Skull Crusher"]
        case .core:
            return ["Plank", "Cable Crunch", "Hanging Leg Raise", "Russian Twist"]
        }
    }
}

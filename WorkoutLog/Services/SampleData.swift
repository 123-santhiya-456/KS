//
//  SampleData.swift
//  WorkoutLog
//
//  Demo entries inserted on the very first launch so that the dashboard,
//  list and personal-best screens are populated straight away.
//

import Foundation

enum SampleData {

    static func workouts(referenceDate: Date = Date()) -> [Workout] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: referenceDate)

        func entry(_ name: String,
                   _ group: MuscleGroup,
                   _ sets: Int,
                   _ reps: Int,
                   _ weight: Double,
                   daysAgo: Int,
                   notes: String = "") -> Workout {
            let day = calendar.date(byAdding: .day, value: -daysAgo, to: today) ?? today
            return Workout(exerciseName: name,
                           muscleGroup: group,
                           sets: sets,
                           reps: reps,
                           weight: weight,
                           date: day,
                           notes: notes,
                           createdAt: day)
        }

        return [
            // Chest
            entry("Bench Press", .chest, 4, 8, 60, daysAgo: 38, notes: "First session, focused on form."),
            entry("Bench Press", .chest, 4, 8, 62.5, daysAgo: 31),
            entry("Bench Press", .chest, 4, 8, 62.5, daysAgo: 24, notes: "Felt tired, matched last week."),
            entry("Bench Press", .chest, 4, 6, 65, daysAgo: 17),
            entry("Bench Press", .chest, 4, 6, 67.5, daysAgo: 10),
            entry("Bench Press", .chest, 4, 5, 70, daysAgo: 3, notes: "New heaviest set. Strong lockout."),
            entry("Incline Dumbbell Press", .chest, 3, 10, 22, daysAgo: 12),

            // Legs
            entry("Squat", .legs, 4, 6, 80, daysAgo: 36),
            entry("Squat", .legs, 4, 6, 85, daysAgo: 29),
            entry("Squat", .legs, 4, 5, 90, daysAgo: 15, notes: "Depth was good."),
            entry("Squat", .legs, 4, 5, 95, daysAgo: 1, notes: "Heavy but controlled."),

            // Back
            entry("Deadlift", .back, 3, 5, 100, daysAgo: 33),
            entry("Deadlift", .back, 3, 5, 110, daysAgo: 19),
            entry("Deadlift", .back, 3, 4, 115, daysAgo: 5, notes: "Grip started to slip on the last rep."),
            entry("Lat Pulldown", .back, 3, 12, 55, daysAgo: 4),

            // Shoulders
            entry("Overhead Press", .shoulders, 3, 10, 35, daysAgo: 27),
            entry("Overhead Press", .shoulders, 3, 8, 40, daysAgo: 13),
            entry("Lateral Raise", .shoulders, 3, 15, 8, daysAgo: 2),

            // Arms
            entry("Barbell Curl", .arms, 3, 12, 25, daysAgo: 21),
            entry("Barbell Curl", .arms, 3, 10, 27.5, daysAgo: 7),

            // Core
            entry("Cable Crunch", .core, 3, 15, 30, daysAgo: 9),
            entry("Cable Crunch", .core, 3, 15, 32.5, daysAgo: 0, notes: "Slow and controlled.")
        ]
    }
}

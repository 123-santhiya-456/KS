//
//  PersonalBestCalculator.swift
//  WorkoutLog
//
//  Pure business logic for personal best tracking (no UI, easy to unit test).
//

import Foundation

enum PersonalBestCalculator {

    /// Finds every workout that is a Personal Best.
    ///
    /// Rule: an entry is a Personal Best when it uses a **heavier weight than any
    /// earlier entry of the same exercise**. The very first entry of an exercise
    /// is the baseline and therefore not a personal best. Because the result is
    /// always recomputed from the full history, editing or deleting an entry
    /// automatically keeps the badges correct.
    static func records(from workouts: [Workout]) -> [PersonalBestRecord] {
        let grouped = Dictionary(grouping: workouts, by: { $0.exerciseKey })
        var result: [PersonalBestRecord] = []

        for (_, entries) in grouped {
            let chronological = entries.sorted(by: Workout.isOlder)
            var bestSoFar: Double?

            for entry in chronological {
                if let currentBest = bestSoFar {
                    if entry.weight > currentBest {
                        result.append(PersonalBestRecord(workout: entry, previousBest: currentBest))
                        bestSoFar = entry.weight
                    }
                } else {
                    bestSoFar = entry.weight
                }
            }
        }

        return result.sorted { Workout.isNewer($0.workout, $1.workout) }
    }
}

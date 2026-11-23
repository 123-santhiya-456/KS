//
//  PersonalBestsViewModel.swift
//  WorkoutLog
//
//  Provides the personal-best timeline and summary numbers.
//

import Foundation
import Combine

final class PersonalBestsViewModel: ObservableObject {

    /// Every personal best, newest first.
    @Published private(set) var records: [PersonalBestRecord] = []

    private var cancellables = Set<AnyCancellable>()

    init(store: WorkoutStore) {
        store.$personalBestRecords
            .sink { [weak self] records in
                self?.records = records
            }
            .store(in: &cancellables)
    }

    /// Number of personal bests.
    var totalRecords: Int { records.count }

    /// Number of different exercises that have at least one personal best.
    var exerciseCount: Int {
        Set(records.map { $0.workout.exerciseKey }).count
    }

    /// The single biggest jump over a previous best.
    var biggestImprovement: PersonalBestRecord? {
        records.max { $0.improvement < $1.improvement }
    }

    /// The heaviest weight among all personal bests.
    var heaviestLift: Double? {
        records.map { $0.workout.weight }.max()
    }
}

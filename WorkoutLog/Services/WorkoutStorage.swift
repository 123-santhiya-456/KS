//
//  WorkoutStorage.swift
//  WorkoutLog
//
//  Persistence layer. Workouts are saved as JSON in the app's Documents folder.
//

import Foundation

/// Abstraction over the persistence mechanism (makes the store testable).
protocol WorkoutStoring {
    /// `true` if a save file already exists.
    var hasStoredData: Bool { get }
    func load() throws -> [Workout]
    func save(_ workouts: [Workout]) throws
}

/// Stores workouts in `Documents/workouts.json`.
final class JSONWorkoutStorage: WorkoutStoring {
    private let fileURL: URL

    init(fileName: String = "workouts.json") {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        self.fileURL = directory.appendingPathComponent(fileName)
    }

    var hasStoredData: Bool {
        FileManager.default.fileExists(atPath: fileURL.path)
    }

    func load() throws -> [Workout] {
        guard hasStoredData else { return [] }
        let data = try Data(contentsOf: fileURL)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode([Workout].self, from: data)
    }

    func save(_ workouts: [Workout]) throws {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(workouts)
        try data.write(to: fileURL, options: [.atomic])
    }
}

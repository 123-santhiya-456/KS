//
//  Extensions.swift
//  WorkoutLog
//
//  Small formatting helpers shared across the app.
//

import Foundation

extension String {
    /// The string without leading / trailing whitespace and newlines.
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension Double {
    /// "70 kg", "62.5 kg" or "Bodyweight" for zero.
    var weightText: String {
        if self == 0 { return "Bodyweight" }
        let isWhole = self.truncatingRemainder(dividingBy: 1) == 0
        return isWhole ? String(format: "%.0f kg", self) : String(format: "%.1f kg", self)
    }

    /// "2,240 kg" style total volume text.
    var volumeText: String {
        "\(Int(self.rounded()).formatted()) kg"
    }
}

extension Date {
    /// "12 Nov 2026"
    var shortDateText: String {
        formatted(date: .abbreviated, time: .omitted)
    }

    /// Single-letter weekday, e.g. "M".
    var narrowWeekdayText: String {
        formatted(.dateTime.weekday(.narrow))
    }
}

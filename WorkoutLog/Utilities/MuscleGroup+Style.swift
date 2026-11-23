//
//  MuscleGroup+Style.swift
//  WorkoutLog
//
//  UI-only details for each muscle group (icon and colour).
//

import SwiftUI

extension MuscleGroup {

    /// SF Symbol shown next to the muscle group.
    var iconName: String {
        switch self {
        case .chest: return "figure.strengthtraining.traditional"
        case .back: return "figure.rower"
        case .legs: return "figure.run"
        case .shoulders: return "figure.arms.open"
        case .arms: return "dumbbell.fill"
        case .core: return "figure.core.training"
        }
    }

    /// Accent colour used for badges and icons.
    var color: Color {
        switch self {
        case .chest: return Color(red: 1.00, green: 0.42, blue: 0.42)
        case .back: return Color(red: 0.36, green: 0.62, blue: 1.00)
        case .legs: return Color(red: 0.30, green: 0.85, blue: 0.55)
        case .shoulders: return Color(red: 0.70, green: 0.50, blue: 1.00)
        case .arms: return Color(red: 1.00, green: 0.70, blue: 0.25)
        case .core: return Color(red: 0.25, green: 0.85, blue: 0.90)
        }
    }

    /// Soft gradient built from the group colour.
    var gradient: LinearGradient {
        LinearGradient(colors: [color, color.opacity(0.55)],
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
    }
}

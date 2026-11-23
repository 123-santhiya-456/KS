//
//  AppTheme.swift
//  WorkoutLog
//
//  Central place for the app's colours and gradients so the whole UI
//  stays visually consistent.
//

import SwiftUI

enum AppTheme {
    // MARK: Colours
    static let backgroundTop = Color(red: 0.04, green: 0.05, blue: 0.13)
    static let backgroundBottom = Color(red: 0.14, green: 0.05, blue: 0.23)
    static let accent = Color(red: 1.00, green: 0.42, blue: 0.21)
    static let accentSecondary = Color(red: 0.96, green: 0.22, blue: 0.47)
    static let gold = Color(red: 1.00, green: 0.78, blue: 0.18)
    static let goldDeep = Color(red: 0.96, green: 0.55, blue: 0.10)
    static let cardFill = Color.white.opacity(0.07)
    static let cardStroke = Color.white.opacity(0.12)
    static let secondaryText = Color.white.opacity(0.62)
    static let danger = Color(red: 1.00, green: 0.35, blue: 0.38)

    // MARK: Gradients
    static var backgroundGradient: LinearGradient {
        LinearGradient(colors: [backgroundTop, backgroundBottom],
                       startPoint: .top,
                       endPoint: .bottom)
    }

    static var accentGradient: LinearGradient {
        LinearGradient(colors: [accent, accentSecondary],
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
    }

    static var goldGradient: LinearGradient {
        LinearGradient(colors: [gold, goldDeep],
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
    }
}

//
//  CardStyle.swift
//  WorkoutLog
//
//  Reusable view modifiers for glass-style cards and input fields.
//

import SwiftUI

struct CardModifier: ViewModifier {
    var padding: CGFloat

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(AppTheme.cardFill, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .strokeBorder(AppTheme.cardStroke, lineWidth: 1)
            )
    }
}

struct InputFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(14)
            .foregroundStyle(Color.white)
            .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .strokeBorder(AppTheme.cardStroke, lineWidth: 1)
            )
    }
}

extension View {
    /// Wraps the view in a translucent rounded card.
    func cardStyle(padding: CGFloat = 16) -> some View {
        modifier(CardModifier(padding: padding))
    }

    /// Styles a text field / secure field for the dark theme.
    func inputFieldStyle() -> some View {
        modifier(InputFieldModifier())
    }
}

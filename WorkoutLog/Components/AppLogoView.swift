//
//  AppLogoView.swift
//  WorkoutLog
//

import SwiftUI

/// Rounded app logo (a small thumbnail stored in the asset catalog).
struct AppLogoView: View {
    var size: CGFloat = 110

    var body: some View {
        Image("AppLogo")
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .clipShape(RoundedRectangle(cornerRadius: size * 0.225, style: .continuous))
            .shadow(color: AppTheme.accent.opacity(0.45), radius: 24, y: 10)
    }
}

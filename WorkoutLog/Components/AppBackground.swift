//
//  AppBackground.swift
//  WorkoutLog
//

import SwiftUI

/// Full-screen dark gradient with two soft glowing blobs. Placed behind every screen.
struct AppBackground: View {
    var body: some View {
        ZStack {
            AppTheme.backgroundGradient

            Circle()
                .fill(AppTheme.accent.opacity(0.20))
                .frame(width: 320, height: 320)
                .blur(radius: 90)
                .offset(x: 150, y: -260)

            Circle()
                .fill(Color.purple.opacity(0.22))
                .frame(width: 300, height: 300)
                .blur(radius: 90)
                .offset(x: -160, y: 300)
        }
        .ignoresSafeArea()
    }
}

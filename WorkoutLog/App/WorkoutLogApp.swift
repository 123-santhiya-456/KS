//
//  WorkoutLogApp.swift
//  WorkoutLog
//
//  App entry point. Creates the shared objects once and injects them into the
//  SwiftUI environment so every screen can use them.
//

import SwiftUI

@main
struct WorkoutLogApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var store = WorkoutStore()
    @StateObject private var router = AppRouter()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authViewModel)
                .environmentObject(store)
                .environmentObject(router)
                .preferredColorScheme(.dark)
        }
    }
}

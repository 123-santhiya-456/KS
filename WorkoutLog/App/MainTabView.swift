//
//  MainTabView.swift
//  WorkoutLog
//
//  The main interface: four tabs. Each tab owns its own NavigationStack.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var store: WorkoutStore
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        TabView(selection: $router.selectedTab) {
            DashboardView(store: store)
                .tabItem { Label("Home", systemImage: "square.grid.2x2.fill") }
                .tag(AppTab.dashboard)

            WorkoutListView(store: store)
                .tabItem { Label("Workouts", systemImage: "list.bullet.rectangle.portrait.fill") }
                .tag(AppTab.workouts)

            LogWorkoutView()
                .tabItem { Label("Log", systemImage: "plus.circle.fill") }
                .tag(AppTab.log)

            PersonalBestsView(store: store)
                .tabItem { Label("Records", systemImage: "trophy.fill") }
                .tag(AppTab.records)
        }
        .tint(AppTheme.accent)
        .overlay(alignment: .top) {
            if let message = router.toastMessage {
                ToastView(message: message)
                    .padding(.top, 8)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: router.toastMessage)
        .alert("Something went wrong",
               isPresented: Binding(
                get: { store.errorMessage != nil },
                set: { newValue in if !newValue { store.errorMessage = nil } }
               )) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(store.errorMessage ?? "")
        }
    }
}

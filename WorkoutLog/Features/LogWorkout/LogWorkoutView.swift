//
//  LogWorkoutView.swift
//  WorkoutLog
//
//  "Log" tab: record a new exercise. After saving, the user is taken to the
//  workout list where the new entry is already visible.
//

import SwiftUI

struct LogWorkoutView: View {
    @EnvironmentObject private var store: WorkoutStore
    @EnvironmentObject private var router: AppRouter
    @StateObject private var viewModel = WorkoutFormViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()

                ScrollView {
                    VStack(spacing: 20) {
                        WorkoutFormContent(viewModel: viewModel)

                        VStack(spacing: 10) {
                            if let message = viewModel.validationMessage {
                                Text(message)
                                    .font(.footnote)
                                    .foregroundStyle(AppTheme.secondaryText)
                                    .multilineTextAlignment(.center)
                            }

                            Button {
                                save()
                            } label: {
                                Label("Save Workout", systemImage: "checkmark.circle.fill")
                            }
                            .buttonStyle(PrimaryButtonStyle())
                            .disabled(!viewModel.isValid)
                            .opacity(viewModel.isValid ? 1 : 0.5)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 24)
                }
                .scrollDismissesKeyboard(.interactively)
            }
            .navigationTitle("Log Workout")
        }
    }

    private func save() {
        guard let workout = viewModel.buildWorkout() else { return }
        store.add(workout)
        viewModel.reset()
        router.selectedTab = .workouts
        router.showToast("Workout saved")
    }
}

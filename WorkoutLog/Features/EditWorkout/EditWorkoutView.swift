//
//  EditWorkoutView.swift
//  WorkoutLog
//
//  Sheet for correcting an existing workout (sets, reps, weight, date, notes...).
//

import SwiftUI

struct EditWorkoutView: View {
    @EnvironmentObject private var store: WorkoutStore
    @EnvironmentObject private var router: AppRouter
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: WorkoutFormViewModel

    init(workout: Workout) {
        _viewModel = StateObject(wrappedValue: WorkoutFormViewModel(workout: workout))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()

                ScrollView {
                    VStack(spacing: 20) {
                        WorkoutFormContent(viewModel: viewModel)

                        if let message = viewModel.validationMessage {
                            Text(message)
                                .font(.footnote)
                                .foregroundStyle(AppTheme.secondaryText)
                                .multilineTextAlignment(.center)
                        }

                        Button {
                            save()
                        } label: {
                            Label("Save Changes", systemImage: "checkmark.circle.fill")
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        .disabled(!viewModel.isValid)
                        .opacity(viewModel.isValid ? 1 : 0.5)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 24)
                }
                .scrollDismissesKeyboard(.interactively)
            }
            .navigationTitle("Edit Workout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
        .presentationDragIndicator(.visible)
    }

    private func save() {
        guard let updated = viewModel.buildWorkout() else { return }
        store.update(updated)
        router.showToast("Changes saved")
        dismiss()
    }
}

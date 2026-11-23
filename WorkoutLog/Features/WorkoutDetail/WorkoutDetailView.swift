//
//  WorkoutDetailView.swift
//  WorkoutLog
//
//  Complete information about one workout, including whether it was a
//  personal best, with Edit and Delete actions.
//

import SwiftUI

struct WorkoutDetailView: View {
    let workoutID: UUID

    @EnvironmentObject private var store: WorkoutStore
    @EnvironmentObject private var router: AppRouter
    @Environment(\.dismiss) private var dismiss

    @State private var isShowingEdit = false
    @State private var isConfirmingDelete = false

    var body: some View {
        ZStack {
            AppBackground()

            if let workout = store.workout(withID: workoutID) {
                ScrollView {
                    VStack(spacing: 18) {
                        heroCard(for: workout)
                        statsGrid(for: workout)
                        infoCard(for: workout)
                        notesCard(for: workout)

                        Button {
                            isConfirmingDelete = true
                        } label: {
                            Label("Delete Workout", systemImage: "trash")
                        }
                        .buttonStyle(DestructiveButtonStyle())
                        .padding(.top, 6)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 24)
                }
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit") { isShowingEdit = true }
                    .disabled(store.workout(withID: workoutID) == nil)
            }
        }
        .sheet(isPresented: $isShowingEdit) {
            if let workout = store.workout(withID: workoutID) {
                EditWorkoutView(workout: workout)
            }
        }
        .confirmationDialog("Delete this workout?",
                            isPresented: $isConfirmingDelete,
                            titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                store.delete(id: workoutID)
                router.showToast("Workout deleted")
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This removes the entry from your training history. This can't be undone.")
        }
    }

    // MARK: - Sections

    private func heroCard(for workout: Workout) -> some View {
        let isPB = store.isPersonalBest(workout)

        return VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 14) {
                Image(systemName: workout.muscleGroup.iconName)
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundStyle(Color.white)
                    .frame(width: 60, height: 60)
                    .background(Color.white.opacity(0.2), in: RoundedRectangle(cornerRadius: 18, style: .continuous))

                VStack(alignment: .leading, spacing: 4) {
                    Text(workout.exerciseName)
                        .font(.system(.title2, design: .rounded, weight: .bold))
                        .foregroundStyle(Color.white)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(workout.muscleGroup.rawValue)
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(Color.white.opacity(0.85))
                }
            }

            if isPB {
                personalBestBanner(for: workout)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(workout.muscleGroup.gradient, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: workout.muscleGroup.color.opacity(0.3), radius: 14, y: 8)
    }

    private func personalBestBanner(for workout: Workout) -> some View {
        HStack(spacing: 10) {
            Image(systemName: "trophy.fill")
                .foregroundStyle(Color.black.opacity(0.8))
            VStack(alignment: .leading, spacing: 2) {
                Text("Personal Best!")
                    .font(.system(.subheadline, design: .rounded, weight: .heavy))
                if let record = store.personalBestRecord(for: workout.id) {
                    Text("+\(record.improvement.weightText) over your previous best of \(record.previousBest.weightText)")
                        .font(.caption)
                }
            }
            .foregroundStyle(Color.black.opacity(0.85))
            Spacer()
        }
        .padding(12)
        .background(AppTheme.goldGradient, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    private func statsGrid(for workout: Workout) -> some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 14), GridItem(.flexible(), spacing: 14)], spacing: 14) {
            StatTile(title: "Sets", value: "\(workout.sets)", icon: "square.stack.3d.up.fill", tint: AppTheme.accent)
            StatTile(title: "Reps", value: "\(workout.reps)", icon: "repeat", tint: Color(red: 0.36, green: 0.62, blue: 1.0))
            StatTile(title: "Weight", value: workout.weight.weightText, icon: "scalemass.fill", tint: Color(red: 0.30, green: 0.85, blue: 0.55))
            StatTile(title: "Total volume", value: workout.totalVolume.volumeText, icon: "chart.bar.fill", tint: Color(red: 0.70, green: 0.50, blue: 1.0))
        }
    }

    private func infoCard(for workout: Workout) -> some View {
        let isPB = store.isPersonalBest(workout)

        return VStack(spacing: 0) {
            infoRow(icon: "calendar", title: "Date", value: workout.date.shortDateText)
            Divider().overlay(AppTheme.cardStroke)
            infoRow(icon: workout.muscleGroup.iconName, title: "Muscle group", value: workout.muscleGroup.rawValue)
            Divider().overlay(AppTheme.cardStroke)
            infoRow(icon: "trophy.fill",
                    title: "Personal best",
                    value: isPB ? "Yes" : "No",
                    valueColor: isPB ? AppTheme.gold : AppTheme.secondaryText)
        }
        .cardStyle(padding: 4)
    }

    private func infoRow(icon: String, title: String, value: String, valueColor: Color = Color.white) -> some View {
        HStack {
            Label(title, systemImage: icon)
                .font(.subheadline)
                .foregroundStyle(AppTheme.secondaryText)
            Spacer()
            Text(value)
                .font(.system(.subheadline, design: .rounded, weight: .semibold))
                .foregroundStyle(valueColor)
        }
        .padding(12)
    }

    private func notesCard(for workout: Workout) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Notes", systemImage: "note.text")
                .font(.system(.subheadline, design: .rounded, weight: .semibold))
                .foregroundStyle(AppTheme.secondaryText)

            Text(workout.notes.isEmpty ? "No notes for this workout." : workout.notes)
                .font(.body)
                .foregroundStyle(workout.notes.isEmpty ? AppTheme.secondaryText : Color.white)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }
}

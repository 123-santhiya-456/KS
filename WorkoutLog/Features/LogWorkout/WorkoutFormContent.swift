//
//  WorkoutFormContent.swift
//  WorkoutLog
//
//  The form fields themselves (exercise, muscle group, sets, reps, weight,
//  date, notes). Reused by the Log screen and the Edit sheet.
//

import SwiftUI

struct WorkoutFormContent: View {
    @ObservedObject var viewModel: WorkoutFormViewModel
    @FocusState private var focusedField: Field?

    private enum Field: Hashable {
        case name
        case weight
        case notes
    }

    var body: some View {
        VStack(spacing: 16) {
            muscleGroupCard
            exerciseCard
            setsRepsCard
            weightCard
            dateCard
            notesCard
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") { focusedField = nil }
            }
        }
    }

    // MARK: - Cards

    private var muscleGroupCard: some View {
        FormCard(title: "Muscle group", icon: "figure.strengthtraining.traditional") {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 10) {
                ForEach(MuscleGroup.allCases) { group in
                    Button {
                        viewModel.muscleGroup = group
                    } label: {
                        VStack(spacing: 6) {
                            Image(systemName: group.iconName)
                                .font(.system(size: 18, weight: .semibold))
                            Text(group.rawValue)
                                .font(.caption.weight(.semibold))
                        }
                        .foregroundStyle(viewModel.muscleGroup == group ? Color.white : group.color)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background {
                            if viewModel.muscleGroup == group {
                                RoundedRectangle(cornerRadius: 14, style: .continuous).fill(group.gradient)
                            } else {
                                RoundedRectangle(cornerRadius: 14, style: .continuous).fill(group.color.opacity(0.14))
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var exerciseCard: some View {
        FormCard(title: "Exercise", icon: "dumbbell.fill") {
            TextField("e.g. Bench Press", text: $viewModel.exerciseName)
                .focused($focusedField, equals: .name)
                .textInputAutocapitalization(.words)
                .submitLabel(.done)
                .inputFieldStyle()

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(viewModel.suggestions, id: \.self) { name in
                        FilterChip(title: name,
                                   isSelected: viewModel.exerciseName.trimmed.lowercased() == name.lowercased()) {
                            viewModel.exerciseName = name
                        }
                    }
                }
            }
        }
    }

    private var setsRepsCard: some View {
        FormCard(title: "Sets & reps", icon: "repeat") {
            Stepper(value: $viewModel.sets, in: viewModel.setsRange) {
                HStack {
                    Text("Sets")
                    Spacer()
                    Text("\(viewModel.sets)")
                        .font(.system(.title3, design: .rounded, weight: .bold))
                        .foregroundStyle(AppTheme.accent)
                }
            }

            Divider().overlay(AppTheme.cardStroke)

            Stepper(value: $viewModel.reps, in: viewModel.repsRange) {
                HStack {
                    Text("Reps")
                    Spacer()
                    Text("\(viewModel.reps)")
                        .font(.system(.title3, design: .rounded, weight: .bold))
                        .foregroundStyle(AppTheme.accent)
                }
            }
        }
        .foregroundStyle(Color.white)
    }

    private var weightCard: some View {
        FormCard(title: "Weight (kg)", icon: "scalemass.fill") {
            TextField("e.g. 62.5  (0 for bodyweight)", text: $viewModel.weightText)
                .keyboardType(.decimalPad)
                .focused($focusedField, equals: .weight)
                .inputFieldStyle()
        }
    }

    private var dateCard: some View {
        FormCard(title: "Date", icon: "calendar") {
            DatePicker("Workout date",
                       selection: $viewModel.date,
                       in: ...Date(),
                       displayedComponents: .date)
                .foregroundStyle(Color.white)
                .tint(AppTheme.accent)
        }
    }

    private var notesCard: some View {
        FormCard(title: "Notes", icon: "note.text") {
            TextField("Form cues, effort, how it felt…", text: $viewModel.notes, axis: .vertical)
                .lineLimit(3...6)
                .focused($focusedField, equals: .notes)
                .inputFieldStyle()
        }
    }
}

/// Titled card container used by every section of the form.
private struct FormCard<Content: View>: View {
    let title: String
    let icon: String
    let content: Content

    init(title: String, icon: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: icon)
                .font(.system(.subheadline, design: .rounded, weight: .semibold))
                .foregroundStyle(AppTheme.secondaryText)

            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }
}

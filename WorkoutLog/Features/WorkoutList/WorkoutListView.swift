//
//  WorkoutListView.swift
//  WorkoutLog
//
//  Scrollable list of every workout (newest first) with search, muscle-group
//  filter chips, swipe-to-edit and swipe-to-delete.
//

import SwiftUI

struct WorkoutListView: View {
    @StateObject private var viewModel: WorkoutListViewModel
    @EnvironmentObject private var router: AppRouter
    @State private var workoutBeingEdited: Workout?

    init(store: WorkoutStore) {
        _viewModel = StateObject(wrappedValue: WorkoutListViewModel(store: store))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()

                VStack(spacing: 0) {
                    filterBar

                    if viewModel.filteredWorkouts.isEmpty {
                        emptyState
                    } else {
                        workoutList
                    }
                }
            }
            .navigationTitle("Workouts")
            .searchable(text: $viewModel.searchText, prompt: "Search exercises")
            .sheet(item: $workoutBeingEdited) { workout in
                EditWorkoutView(workout: workout)
            }
        }
    }

    // MARK: - Subviews

    /// Horizontal row of muscle-group chips.
    private var filterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                FilterChip(title: "All", isSelected: viewModel.selectedGroup == nil) {
                    viewModel.selectedGroup = nil
                }

                ForEach(MuscleGroup.allCases) { group in
                    FilterChip(title: group.rawValue,
                               icon: group.iconName,
                               isSelected: viewModel.selectedGroup == group) {
                        viewModel.toggleGroup(group)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
    }

    private var workoutList: some View {
        List {
            ForEach(viewModel.filteredWorkouts) { workout in
                ZStack {
                    // Invisible link so the whole card is tappable without a chevron.
                    NavigationLink {
                        WorkoutDetailView(workoutID: workout.id)
                    } label: {
                        EmptyView()
                    }
                    .opacity(0)

                    WorkoutRowView(workout: workout,
                                   isPersonalBest: viewModel.isPersonalBest(workout))
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button(role: .destructive) {
                        viewModel.delete(workout)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                    Button {
                        workoutBeingEdited = workout
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                    .tint(AppTheme.accent)
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }

    @ViewBuilder
    private var emptyState: some View {
        if viewModel.isFiltering {
            EmptyStateView(icon: "magnifyingglass",
                           title: "No matches",
                           message: "Try a different exercise name or muscle group.",
                           actionTitle: "Clear filters") {
                viewModel.clearFilters()
            }
        } else {
            EmptyStateView(icon: "dumbbell.fill",
                           title: "No workouts yet",
                           message: "Log your first exercise to start building your training history.",
                           actionTitle: "Log a workout") {
                router.selectedTab = .log
            }
        }
    }
}

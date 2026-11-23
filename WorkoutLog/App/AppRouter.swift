//
//  AppRouter.swift
//  WorkoutLog
//
//  Tiny navigation helper: remembers the selected tab (so any screen can jump
//  to another one) and shows short confirmation toasts.
//

import SwiftUI

/// The tabs of the main interface.
enum AppTab: Hashable {
    case dashboard
    case workouts
    case log
    case records
}

final class AppRouter: ObservableObject {
    @Published var selectedTab: AppTab = .dashboard
    @Published private(set) var toastMessage: String?

    /// Shows a toast for two seconds.
    func showToast(_ message: String) {
        toastMessage = message
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            guard let self = self else { return }
            // Only clear if no newer toast replaced this one.
            if self.toastMessage == message {
                self.toastMessage = nil
            }
        }
    }
}

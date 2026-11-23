# Workout Log (Project 05) – SwiftUI / MVVM

iPhone-only, portrait-only workout tracker with Face ID, dashboard, search & filter and personal best tracking.

## How to run
1. Unzip, double-click `WorkoutLog.xcodeproj` (Xcode 15 or newer, iOS 17+ simulator/device).
2. Select the **WorkoutLog** target → *Signing & Capabilities* → choose your **Team** (only needed for a real iPhone; the simulator works without it).
3. Pick an iPhone simulator and press **Run (⌘R)**.
4. If Xcode offers "Update to recommended settings", click *Perform Changes*.

### Testing Face ID in the simulator
* `Features ▸ Face ID ▸ Enrolled` (enable), then tap **Unlock with Face ID** and use `Features ▸ Face ID ▸ Matching Face`.
* With Face ID **not** enrolled / unsupported, the app shows the local login screen. On first launch it asks you to create a username + password; afterwards you sign in with them.

The app seeds ~20 demo workouts on first launch so every screen is populated. Delete the app to reset.

## Architecture (MVVM)
```
WorkoutLog/
├── App/            WorkoutLogApp, RootView (auth gate), MainTabView, AppRouter
├── Models/         Workout, MuscleGroup, PersonalBestRecord      (pure data)
├── Services/       BiometricAuthService, CredentialService, WorkoutStorage (JSON),
│                   PersonalBestCalculator, SampleData            (business logic / IO)
├── Stores/         WorkoutStore  – single source of truth (ObservableObject)
├── Utilities/      AppTheme, Extensions, ExerciseCatalog, MuscleGroup+Style
├── Components/     Reusable UI: cards, badges, chips, buttons, toast, empty state
├── Features/       One module per screen, each with View + ViewModel
│   ├── Authentication   LockView (Face ID) · LoginView (fallback) · AuthViewModel
│   ├── Dashboard        DashboardView · DashboardViewModel
│   ├── WorkoutList      WorkoutListView · WorkoutRowView · WorkoutListViewModel (search + filter + delete)
│   ├── LogWorkout       LogWorkoutView · WorkoutFormContent · WorkoutFormViewModel
│   ├── WorkoutDetail    WorkoutDetailView (details + PB status + edit + delete)
│   ├── EditWorkout      EditWorkoutView (reuses the form)
│   └── PersonalBests    PersonalBestsView · PersonalBestsViewModel
└── Assets.xcassets App icon, accent colour, lightweight 256 px logo thumbnail
```

Data flow: `View → ViewModel → WorkoutStore → JSON file`. Every ViewModel observes `WorkoutStore`, so adding, editing or deleting a workout updates the list, dashboard and records instantly.

## Feature → code map
| # | Feature | Where |
|---|---------|-------|
| 1 | Face ID + local login fallback | `Features/Authentication`, `Services/BiometricAuthService` |
| 2 | Dashboard | `Features/Dashboard` |
| 3 | Workout list (newest first) | `Features/WorkoutList` |
| 4 | Log workout | `Features/LogWorkout` |
| 5 | Workout details | `Features/WorkoutDetail` |
| 6 | Edit workout | `Features/EditWorkout` |
| 7 | Delete workout | swipe in list + button in details (with confirmation) |
| 8 | Search & filter | `WorkoutListViewModel` (search bar + muscle-group chips) |
| 9 | Personal bests | `Services/PersonalBestCalculator`, `Features/PersonalBests` |

## Personal Best rule
An entry is a PB when its weight is **heavier than every earlier entry of the same exercise** (name compared case-insensitively). The first entry of an exercise is the baseline. PBs are recomputed from the full history, so edits and deletes always keep the badges correct.

## Notes
* Deployment target iOS 17, iPhone only (`TARGETED_DEVICE_FAMILY = 1`), portrait only.
* `NSFaceIDUsageDescription` is set in the target's build settings (Info tab).
* Bundle id is `com.wipro.WorkoutLog` – change it if Xcode reports a signing conflict.

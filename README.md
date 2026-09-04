# vocabulary_tracker

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## initial File Structure

```
lib/
├── database/
│   └── app_database.dart          # 🗄️ SQLite database initialization & helper
│
├── features/
│   ├── auth/              # Everything related to user data
│   │   ├── data/            # SQLite db queries for users
│   │   │   └── user_repository.dart
│   │   └── presentation/    # Login/Profile screens
│   │   │   ├── auth_screen.dart      # 👤 authentication screen
│   │   │   └── profile_screen.dart      # 👤 Profile Page
│   │   └── state/           # Auth controller/notifier
│   │       └── auth_state.dart      # 👤 authentication state
│   │
│   ├── vocabulary/             # Everything related to user vocabulary
│   │   ├── data/            # SQLite db queries for writings
│   │   │   └── vocabulary_repository.dart
│   │   ├── presentation/    # Editor/List screens
│   │   │   ├── home_screen.dart        # 🏠 Home Page (e.g., highlights/stats)
│   │   │   ├── write_screen.dart       # ✍️ Write Page (the text editor)
│   │   │   └── history_screen.dart     # 📜 History Page (list of past writings)
│   │   └── state/           # Vocabulary controller/notifier
│   │       └── vocabulary_state.dart
│   │
│   └── dashboard/
│       └── presentation/
│           └── dashboard_screen.dart   # 🧭 The wrapper with the bottom bar
│
└── main.dart                      # 🚀 Minimal App Entry
```
# vocabulary_tracker

My first Flutter Project. This is basically vocabulary tracker but with fluttet and sulit. 



## File Structure

```
lib/
├── helpers/
│   ├── preference_manager.darts
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
│   │   │   └── vocabulary.dart
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
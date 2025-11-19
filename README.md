# Mini Lead Manager CRM

Flutter CRM-style lead tracker backed by SQLite and powered by Provider state management. Create, search, filter, update, and export leads with a polished Material 3 UI and smooth transitions.

## Features
- Persistent SQLite storage with sqflite
- Provider-based global state for CRUD, filtering, and search
- Lead list with search bar, status chips, animated tiles, and pull-to-refresh
- Add, edit, delete, and detail screens with status progression (New → Contacted → Converted/Lost)
- Status badges, theme-aware design, and smooth page transitions
- Clipboard JSON export of all leads for quick sharing/backups
- Light and dark Material 3 themes with system detection

## Tech Stack
- Flutter 3.8+
- Provider
- sqflite + path_provider + path

## Project Structure
```
lib/
├── db/db_service.dart          # SQLite setup and queries
├── models/lead.dart            # Lead entity and status helpers
├── providers/lead_provider.dart# Business logic, filters, export
├── screens/
│   ├── home/lead_list_screen.dart
│   ├── add/add_lead_screen.dart
│   ├── details/lead_details_screen.dart
│   └── edit/edit_lead_screen.dart
├── widgets/
│   ├── lead_tile.dart
│   └── status_badge.dart
└── main.dart                   # App bootstrap and theming
```

## Getting Started
```bash
flutter pub get
flutter run
```

## Testing
```bash
flutter analyze
flutter test
```

## Notes
- Requires iOS/Android/emulator with SQLite support (default Flutter targets)
- Clipboard export copies all stored leads as JSON

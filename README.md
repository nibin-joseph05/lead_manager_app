# Mini Lead Manager CRM

A lightweight CRM-style lead tracking app built with Flutter, using SQLite for persistence and Provider for state management. Manage leads with creation, search, filtering, editing, status updates, and quick JSON export, all wrapped in a clean Material 3 interface.

## Features
- Persistent SQLite storage using sqflite
- Provider-managed CRUD, filtering, and search
- Lead list with search bar, status chips, animated tiles, and pull-to-refresh
- Add, edit, delete, and detail screens with status progression (New → Contacted → Converted/Lost)
- Status badges, theme-aware Material 3 UI, and smooth page transitions
- Clipboard JSON export for quick sharing or backups
- Light and dark themes with system detection

## Tech Stack
- Flutter 3.8+
- Provider
- sqflite
- path_provider
- path

## Project Structure
```
lib/
├── db/
│   └── db_service.dart
├── models/
│   └── lead.dart
├── providers/
│   └── lead_provider.dart
├── screens/
│   ├── home/lead_list_screen.dart
│   ├── add/add_lead_screen.dart
│   ├── details/lead_details_screen.dart
│   └── edit/edit_lead_screen.dart
├── widgets/
│   ├── lead_tile.dart
│   └── status_badge.dart
└── main.dart
```

## Getting Started
```bash
flutter pub get
flutter run
```

## APK
- Download the latest APK: *(add Google Drive or GitHub Release link here)*

## Testing
```bash
flutter analyze
flutter test
```

## Notes
- Works on Android, iOS, and emulators with SQLite enabled
- Clipboard export copies all stored leads as JSON
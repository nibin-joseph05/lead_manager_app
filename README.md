Mini Lead Manager CRM

A lightweight CRM-style lead tracking app built with Flutter, featuring persistent SQLite storage and Provider-based state management. Users can add, view, search, filter, update, edit, delete, and export leads in a clean Material 3 UI with smooth transitions and light/dark theme support.

## Features

### Core
- Add new leads with name, contact, and optional notes
- View leads in a scrollable, animated list
- Lead detail page with full information
- Update lead status (New → Contacted → Converted/Lost)
- Edit existing leads
- Delete leads permanently
- Local persistence with SQLite (sqflite)
- Provider-driven global state

### Filtering
- Status chips for All, New, Contacted, Converted, Lost

### Search
- In-memory search by name or contact

### Bonus
- Light and dark Material 3 theme
- Smooth page transitions
- Animated list tiles
- Status badges
- Pull-to-refresh
- JSON export to clipboard
- Clean folder structure and spacing

## Tech Stack
- Flutter 3.8+
- Provider
- sqflite
- path_provider
- path

## Project Structure
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

## How to Run
flutter pub get
flutter run

## APK Download
- Debug build: https://drive.google.com/drive/folders/1GzGHFOdD6IehDDGwcncuCwuljS3o_sYn?usp=sharing

## Screen Recording (1–2 minutes)
- Overview, add, view, filter, search, edit, status update, delete, export, structure
- Included in the Google Drive folder above

## Testing
flutter analyze
flutter test

## Assignment Compliance Summary
- Clean modular code with separation of concerns
- Provider-based reactive architecture with reusable widgets
- SQLite CRUD with persistence across sessions
- Polished Material 3 UI, animations, badges, and spacing
- Fully functional app meeting all required and bonus criteria

## Notes
- Works on Android, iOS, and emulators with SQLite enabled
- JSON export copies all stored leads to the clipboard
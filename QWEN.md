# QWEN.md — Quran App ("طمأنينة")

## Project Overview

**طمأنينة (Tamaneena)** is a comprehensive Islamic Flutter application focused on Quran reading, audio listening, prayer times, qibla direction, athkar, and many other Islamic features. The app supports Arabic and English languages, full offline mode, dark/light themes, and targets Android and iOS platforms.

### Key Features (26+ features)
- Quran reading with Uthmanic script and multiple fonts
- Quran audio streaming & offline download with multiple reciters
- Prayer time calculation with geolocation and notifications
- Qibla compass with interactive map
- Athkar (morning/evening/post-prayer) with tasbih counter
- Advanced Quran search (without diacritics)
- Bookmarks with notes and organization
- Allah's 99 Names with explanations
- Islamic library (books & references)
- 40 Hadith Nawawi
- Ruqyah Shari'ah content
- Daily Wird (reading plans)
- Young Muslim content
- Notification scheduling
- Full offline support with auto-sync

### Architecture
- **Pattern**: Clean Architecture + BLoC/Cubit
- **Layers**: Presentation → BLoC → Use Cases → Entities → Repositories → Data Sources
- **State Management**: `flutter_bloc` + `rxdart`
- **Dependency Injection**: `get_it`
- **Local Storage**: `sqflite` (SQLite), `shared_preferences`
- **Networking**: `dio` + `connectivity_plus`
- **Audio**: `just_audio` + `flutter_downloader`

## Tech Stack

| Category | Technology |
|---|---|
| Framework | Flutter SDK ≥ 3.6.0, Dart ^3.6.0 |
| State Management | flutter_bloc, rxdart, equatable |
| Local DB | sqflite |
| Network | dio, connectivity_plus |
| Audio | just_audio, audio_video_progress_bar |
| Maps/Location | flutter_map, geolocator, flutter_qiblah, latlong2 |
| Prayer Times | adhan, adhan_dart |
| Firebase | firebase_core, firebase_messaging, firebase_remote_config, cloud_firestore |
| Notifications | flutter_local_notifications |
| UI | flutter_screenutil, skeletonizer, lottie, flutter_svg, pull_to_refresh, smooth_sheets |
| DI | get_it |
| Code Gen | flutter_gen_runner, build_runner |
| Linting | very_good_analysis, flutter_lints |
| Custom Package | `quran_library` (local package at `flutter_packages/quran_library`) |

## Project Structure

```
lib/
├── core/                          # Shared core modules
│   ├── app_localizations/         # i18n (Arabic/English)
│   ├── bloc/                      # Global BLoCs (Theme, Connectivity, Audio)
│   ├── cash/                      # Caching layer
│   ├── components/                # Reusable UI components
│   ├── device_sync/               # Device synchronization
│   ├── extensions/                # Dart extension utilities
│   ├── failure/                   # Failure handling models
│   ├── helper/                    # Helper utilities (e.g., DioHelper)
│   ├── jsons/                     # JSON model classes
│   ├── local_database/            # SQLite database service
│   ├── models_public/             # Public shared models
│   ├── notification/              # Local & Firebase notifications
│   ├── package/                   # Package wrappers
│   ├── server_failure/            # Server failure handling
│   ├── services/                  # Services (Download, Location, Permission, TimeZone, etc.)
│   ├── shared/                    # Shared utilities
│   ├── theme/                     # Theme & color management
│   ├── util/                      # Utility functions
│   ├── widgets/                   # Shared widgets
│   └── constant.dart              # App-wide constants
│
├── features/                      # Feature modules (27 features)
│   ├── allh_name/                 # Allah's 99 Names
│   ├── another_screen/            # Additional screens
│   ├── audios/                    # Audio-related
│   ├── bookmark/                  # Bookmarks management
│   ├── books/                     # Islamic library
│   ├── categories/                # Content categorization
│   ├── download/                  # Download management
│   ├── hadith_40/                 # 40 Hadith Nawawi
│   ├── home/                      # Home screen
│   ├── manage_version/            # Version management
│   ├── my_adia/                   # Personal supplications
│   ├── notification_schedules/    # Scheduled notifications
│   ├── prayer_time/               # Prayer times
│   ├── qiblah/                    # Qibla direction
│   ├── quran_audio/               # Quran audio player
│   ├── quran_plan/                # Quran reading plans
│   ├── read_quran/                # Quran reader
│   ├── ruqia_shareia/             # Ruqyah content
│   ├── sabih/                     # Tasbih counter
│   ├── search/                    # Quran search
│   ├── setting/                   # Settings
│   ├── setting_notification/      # Notification settings
│   ├── smart_outreach/            # Smart outreach features
│   ├── thikr/                     # Daily athkar
│   ├── wird/                      # Daily reading plan
│   ├── young_muslim/              # Young Muslim content
│   └── zkar_after_pray/           # Post-prayer athkar
│
├── gen/                           # Auto-generated files (flutter_gen)
├── main.dart                      # Entry point
└── main_view.dart                 # Main app view
```

## Key Commands

### Initial Setup
```bash
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### Run
```bash
flutter run                          # Run on connected device
flutter run -d android               # Run on Android
flutter run -d ios                   # Run on iOS
```

### Build Release
```bash
# Android App Bundle (Google Play)
flutter build appbundle --release

# Android APK (per ABI)
flutter build apk --release --split-per-abi

# With obfuscation
flutter build appbundle --obfuscate --split-debug-info=symbols/

# iOS
flutter build ios --release
```

### Code Quality
```bash
flutter analyze                      # Static analysis
flutter test                         # Run tests
```

### Dependency Management
```bash
flutter pub outdated                 # Check outdated packages
flutter pub upgrade                  # Upgrade packages
```

### Code Generation (Watch Mode)
```bash
dart run build_runner watch --delete-conflicting-outputs
```

## Development Conventions

### Linting & Analysis
- Uses `very_good_analysis` and `flutter_lints`
- Strict type checking: `strict-casts`, `strict-inference`, `strict-raw-types`
- 150+ lint rules enforced (see `analysis_options.yaml`)
- Linter rules cover: naming, formatting, null-safety, async best practices, performance, and more

### Code Style
- Prefer `single_quotes` for strings
- Prefer `final` for fields, locals, and loop variables
- Use `prefer_const_constructors` and `prefer_const_declarations`
- Trailing commas required (`require_trailing_commas`)
- Lines longer than 80 chars flagged (`lines_longer_than_80_chars`)
- Use `super_parameters` (Dart 2.17+)
- No `print` statements (`avoid_print`)
- Use `logger` package for logging

### Asset Generation
- Uses `flutter_gen_runner` for type-safe asset access
- Generated files output to `lib/gen/`
- Excludes `assets/raw/**` from generation
- Supports: images, SVG, Lottie animations

### Testing
- Test directory exists at `test/`
- Uses `flutter_test` SDK
- Follows BLoC pattern testing (entities, use cases, blocs)

### Architecture Patterns
- Feature-first folder structure
- Each feature follows Clean Architecture:
  ```
  feature/
  ├── presentation/    # Screens, widgets, BLoCs
  ├── domain/          # Use cases, entities
  └── data/            # Repositories, data sources
  ```
- BLoC pattern for state management with `flutter_bloc`
- Repository pattern for data abstraction
- Use case pattern for business logic encapsulation

## Important Notes

### Firebase Setup
- `firebase.json` at root for Firebase CLI configuration
- `google-services.json` required in `android/app/` (not committed)
- Firebase services used: Core, Messaging, Remote Config, Cloud Firestore
- Background message handler registered for iOS

### Android-Specific
- `key.properties` file required in `android/` for app signing (not committed)
- Keystore must be converted to PKCS12 format for modern Android signing
- Location permission required for prayer times and qibla
- Notification permission required for prayer alerts

### Custom Package
- `quran_library` is a local package at `flutter_packages/quran_library`
- Provides core Quran display functionality
- Initialize with `QuranLibrary.init()` in `main.dart`

### Fonts
The app ships with multiple Arabic fonts:
- ios-1, ios-2, ios-3
- uthmanic, uthmanic2
- kufi (variable weight)
- naskh (variable weight)
- amiri_quran
- Scheherazade

### API Resources
- Surah Audio CDN: `https://raw.githubusercontent.com/islamic-network/cdn/master/info/cdn_surah_audio.json`
- Quran API: `https://api.alquran.cloud/v1/edition/format/audio`

## Privacy Policy
Full privacy policy available at [`PRIVACY_POLICY.md`](./PRIVACY_POLICY.md)

## License
This project is licensed under the [MIT License](./LICENSE).

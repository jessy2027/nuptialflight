# Changelog

## [3.0.0] – 2025-07-13

### ✨ Major Updates

* **Flutter SDK upgrade:** Project migrated & tested on Flutter 3.22+ and Dart 3.6 (null-safety everywhere).
* **Material 3 UI:** Switched light & dark themes to `ColorScheme.fromSeed` with `useMaterial3: true`.
* **State-management overhaul:** Implemented Riverpod 2.x (`flutter_riverpod`) – no more manual timers or setState-heavy logic.
* **Dependencies refreshed:** Ran `flutter pub upgrade --major-versions`, resolved 60+ package upgrades, removed git overrides.
* **URL cleanup:** Replaced all hard-coded BitBot endpoints with `.env` variables (`API_BASE_URL`, `MAP_TILES_URL`, …).
* **Backend access:** ArangoDB client now reads `API_BASE_URL` from environment; Weather tiles & CORS proxy likewise.

### 🛠️ Codebase Refactor

* Converted `MyHomePage` to `ConsumerStatefulWidget`; weather & location flow handled by providers.
* Added providers (`weatherFetcherProvider`, `weatherStreamProvider`, `hourlyPercentagesProvider`, `dailyPercentagesProvider`).
* Replaced deprecated APIs (`desiredAccuracy`, `registerBackgroundCallback`, `launch`, `canLaunch`, `.withOpacity`).
* Removed unused variables & legacy timers.
* Added `assets/env.example` with all required keys; app fails gracefully if values missing.

### 📦 Package Changes

```
+ flutter_riverpod 2.6.1
+ riverpod_lint 2.3.0 (dev)
↑ geolocator 14.x → 14.0.2
↑ flutter_map 8.x → 8.2.1
↑ flutter_local_notifications 19.0.0 → 19.3.0
… and many others (see `flutter pub upgrade` log)
```

### 🔧 Project Clean-up

* Removed `dependency_overrides` section.
* Deleted unused assets/code; standardised directory structure under `lib/core`, `lib/features`.

### 🚀 Migration Notes

1. Copy `assets/env.example` to `assets/.env` and fill values.
2. Run `flutter pub get`.
3. Build & deploy as usual (`flutter run`, `flutter build apk`, …).

## Earlier versions

Refer to git history for pre-3.x changes. 
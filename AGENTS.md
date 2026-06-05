# Tamaneena Agent Guide

This is the canonical working guide for agents editing this repository.
`QWEN.md` is intentionally removed and must not be recreated as a source of
truth. Always read this file plus the current code before making changes.

## Product Identity

Tamaneena is an Arabic-first Islamic Flutter app for Quran reading, audio,
prayer times, athkar, daily wird, widgets, children content, travel helpers,
smart outreach/Fajr companionship, and personal worship reminders.

The app should feel quiet, devotional, compact, polished, and practical. It is
not a marketing site. Screens should help the user act quickly without visual
noise.

Core product rules:

- Arabic is the primary UX language and RTL is the default layout direction.
- Keep copy short, respectful, and calm.
- Prefer small, useful controls over large decorative sections.
- Preserve the existing dark/gold visual identity.
- Never introduce intrusive permissions, startup permission gates, or
  platform-impossible behavior.

## Before Any Task

- Inspect the relevant files first. Do not rely on memory or old summaries.
- Use `rg` and `rg --files` for search.
- Check `git status --short` before and after meaningful edits.
- Treat existing dirty files as user work unless you know you changed them.
- Do not revert, reset, or overwrite unrelated changes.
- Keep changes scoped to the requested feature or bug.
- Use `apply_patch` for manual edits.
- Prefer the existing feature's pattern over inventing a new structure.
- Run the smallest useful verification after code changes.

## Repository Map

Important top-level areas:

- `lib/main.dart`: app startup, Firebase init, service locator, database,
  cache, Quran library init, home widget refresh/background setup.
- `lib/main_view.dart`: root providers, `MaterialApp`, theme mode, main app
  lifecycle, update checks, prayer refresh on resume.
- `lib/core`: shared infrastructure, services, notification system, theme,
  extensions, reusable widgets, cache, database, helpers.
- `lib/features`: feature-first modules.
- `lib/gen`: generated assets/fonts from `flutter_gen`.
- `flutter_packages/quran_library`: local Quran package. Use it for Quran
  data and rendering.
- `android/app/src/main`: Android manifest, Kotlin native channels, app
  widgets, notification resources.
- `ios/Runner`: iOS app delegate, notification/audio resources.
- `ios/TamaneenaWidgets`: WidgetKit widgets and lock screen widgets.
- `test`: currently includes widget smoke tests plus focused tests for
  young Muslim assets and floating adhkar selection.

Current feature folders include:

- `home`, `setting`, `setting_notification`, `manage_version`
- `prayer_time`, `qiblah`, `traveler`
- `read_quran`, `quran_audio`, `quran_plan`, `daily_wird`, `wird`
- `floating_adhkar`, `thikr`, `zkar_after_pray`, `sabih`
- `young_muslim`, `smart_outreach`, `home_widgets`
- `books`, `audios`, `download`, `bookmark`, `categories`
- `allh_name`, `another_screen`, `hadith_40`, `ruqia_shareia`, `my_adia`

## Main Stack

Use the existing stack unless the task clearly requires otherwise:

- Framework: Flutter, Dart SDK `^3.6.0`
- State management: `flutter_bloc`, `equatable`, `rxdart`
- Dependency injection: `get_it`
- Local storage: `shared_preferences`, `sqflite`
- Networking: `dio`, `connectivity_plus`
- Firebase: `firebase_core`, `firebase_messaging`, `firebase_remote_config`,
  `cloud_firestore`
- Notifications: `flutter_local_notifications`, `timezone`,
  `flutter_timezone`, `permission_handler`
- Prayer times: `adhan`, `adhan_dart`
- Location/maps: `geolocator`, `geocoding`, `flutter_map`, `latlong2`,
  `flutter_qiblah`
- Audio/download: `just_audio`, `audio_video_progress_bar`,
  `flutter_downloader`
- UI: `flutter_screenutil`, `hugeicons`, `lottie`, `flutter_svg`,
  `skeletonizer`, `smooth_sheets`, `pull_to_refresh`, `cached_network_image`
- Widgets/background: `home_widget`, `workmanager`
- Android overlay: `flutter_overlay_window`
- Updates: `in_app_update`, `upgrader`
- Quran: local `quran_library` package

## Startup Flow

`main.dart` performs important setup in this order:

- `WidgetsFlutterBinding.ensureInitialized()`
- package info
- timezone setup through `TimeZoneService`
- download service initialization
- Firebase initialization
- `setupServiceLocator()`
- bloc observer
- Dio initialization
- local database initialization
- cache load through `CacheConfig.loadConfig()`
- `QuranLibrary.init()`
- `HomeWidgetsService.refreshAll()`
- `HomeWidgetsService.startBackgroundUpdates()`
- iOS Firebase background message handler registration

Do not move startup work casually. Background tasks and widgets depend on
cache, Quran initialization, and plugin registration being available.

## Architecture

The app is feature-first and mostly follows:

```text
feature/
  data/
  domain/
  presentation/
```

Not every legacy feature is perfectly layered. Follow the local feature style
first. Add a repository/service/bloc only when it reduces real complexity or
matches an existing feature contract.

Rules:

- Keep UI in `presentation`.
- Keep persistence/network/native calls in `data` services or repositories.
- Keep shared cross-feature services in `lib/core` only when they are truly
  shared.
- Prefer `Bloc`/`Cubit` for real state transitions.
- Avoid adding global singletons outside `service_locator.dart` unless the
  existing service is already singleton-style.

## Dependency Injection

The central DI file is:

- `lib/core/services/service_locator.dart`

It registers:

- Quran/read/audio/radio/daily wird/floating adhkar feature dependencies
- notification services and orchestrator
- Firestore/Messaging/connectivity/device sync
- smart outreach services and repository
- repositories and blocs

When adding a service:

- Register it in the feature DI file if it belongs to a feature.
- Register it in `service_locator.dart` if it is used across features.
- Avoid creating duplicate service instances in multiple screens if the
  existing pattern uses `sl<T>()`.

## Routing And Navigation

The root route is defined in:

- `lib/core/shared/resources/routes_manager.dart`

Many screens navigate directly with `context.push(...)` from
`lib/core/util/my_extensions.dart`.

Rules:

- Preserve RTL and Arabic labels in navigation UI.
- When pushing a screen that needs the current bloc, use
  `BlocProvider.value` as existing prayer/settings flows do.
- Do not add a large router refactor for small tasks.

## Theme System

The active `MaterialApp` themes are:

- `lib/core/util/light_theme.dart`
- `lib/core/util/dark_theme.dart`

The main color source is:

- `lib/core/util/theme_colors.dart`

The current brand palette:

- Gold/accent: `AppColors.gold` (`0xFFC3A46B`)
- Light background/surface: `AppColors.background`, `AppColors.surface`
- Dark background/surface: `AppColors.darkBackground`, `AppColors.darkSurface`
- Dark outline: `AppColors.darkOutline`
- Secondary text: `AppColors.secondaryText`, `AppColors.darkSecondaryText`
- Error/success: `AppColors.error`, `AppColors.success`

There is also an older theme-color manager:

- `lib/core/theme/theme_manager.dart`
- `lib/core/theme/quran_themes.dart`
- `ThemeBloc`

The old manager is still used in parts of the app and by widget color data.
Do not remove it unless the task is specifically about theme migration.

Use these context extensions from
`package:quran_app/core/extensions/theme_extensions.dart`:

- `context.primaryColor`
- `context.scaffoldBackgroundColor`
- `context.surfaceColor`
- `context.surfaceVariant`
- `context.onSurfaceColor`
- `context.onSurfaceVariant`
- `context.outline`
- `context.outlineVariant`
- `context.shadow`
- `context.errorColor`
- `context.titleMedium`, `context.bodyMedium`, etc.

Theme rules:

- Prefer context theme values over hard-coded colors.
- Use alpha overlays, not new saturated palettes.
- Keep surfaces compact and low contrast.
- Preserve dark mode. Test both light and dark when changing shared widgets.
- Avoid one-off color systems inside features.

## Typography

The active theme uses `FontFamily.ios1` with fallback to `ios2`.

Available fonts in the app include:

- `ios-1`, `ios-2`, `ios-3`
- `uthmanic`, `uthmanic2`
- `kufi`, `naskh`, `amiri_quran`, `Scheherazade`

Rules:

- Use theme text styles for normal UI.
- Use Quran fonts only for Quran/ayah display when appropriate.
- Keep labels small and readable.
- Do not scale font size directly from viewport width.
- Avoid negative letter spacing in new UI.

## UI Style

The current design direction is compact, elegant, and calm:

- dark or neutral surfaces
- gold accent
- small badges
- light borders
- subtle shadows
- concise text
- no loud gradients
- no large decorative hero blocks inside app tools

Preferred patterns:

- `AppScaffoldWidget` or `NormalAppScaffoldWidget` for screens.
- `CardWidget` or local compact cards for repeated items.
- `showModalBottomSheet` or existing sheet helpers for bottom sheets.
- `SegmentedButton`, tabs, chips, switches, sliders, and menus for controls.
- `Wrap` for social/action chips.
- `SliverList`/`SliverGrid` for long sliver content.

Avoid:

- cards inside cards
- oversized icon badges
- decorative blobs/orbs
- explanatory marketing text
- large empty vertical gaps
- nested scrollables without constraints
- unrelated redesigns while fixing a small bug

## Scrolling Rules

Important pitfall:

- `AppScaffoldWidget` wraps content through `AppSliverWidget`, which uses a
  `CustomScrollView`.
- Do not put an unconstrained vertical `ListView` inside `body`.

If a list is inside `AppScaffoldWidget`:

- Prefer `slivers` with `SliverList`/`SliverGrid`.
- Or use a `Column` if the content is short.
- Or use `ListView` only with `shrinkWrap: true` and
  `NeverScrollableScrollPhysics` when it is intentionally nested.

This avoids the Flutter error:

```text
Vertical viewport was given unbounded height.
```

## Icons

The app's icon system is:

- `hugeicons`
- `lib/core/widgets/app_icon.dart`

Use:

- `AppIcon(...)`
- `AppIcons.*`

Avoid new direct usage of:

- `Icons.*`
- raw `HugeIcon`

`AppIcon` intentionally applies visual padding so hugeicons do not look too
large inside containers. This was a repeated UX issue.

Icon sizing guidance:

- Inline text icon: `14.sp` to `16.sp`
- Small chip icon: `14.sp` to `16.sp`
- Bottom/nav icon outer size: `18.sp` to `22.sp`
- Card badge icon outer size: `18.sp` to `24.sp`
- Badge/container size: usually `28.w` to `40.w`
- If the icon still looks large, increase `visualPadding` or reduce `size`.

When adding a new icon, first add/choose a semantic alias in `AppIcons` if it
will be reused.

## Reusable UI And Extensions

Useful shared files:

- `lib/core/widgets/app_icon.dart`
- `lib/core/components/card_widget.dart`
- `lib/core/components/glass_card_widget.dart`
- `lib/core/widgets/app_scaffold/*`
- `lib/core/components/sheet/*`
- `lib/core/components/bottom_sheet/*`
- `lib/core/extensions/colors_extension.dart`
- `lib/core/extensions/text_styles_extension.dart`
- `lib/core/extensions/spacing_extension.dart`
- `lib/core/extensions/request_state/*`

Prefer these helpers over duplicating large local components.

## Notifications Contract

All app notifications must be controllable from notification settings.

Core files:

- `lib/core/notification/base_notification_service.dart`
- `lib/core/notification/notification_service.dart`
- `lib/core/notification/notification_orchestrator_service.dart`
- `lib/core/notification/channel/notification_channel.dart`
- `lib/features/setting_notification/data/constant/notification_data_const.dart`
- `lib/features/setting_notification/data/seed/notification_settings_seeder.dart`
- `lib/features/setting_notification/data/database/database_notification_setting_service.dart`
- `lib/features/setting_notification/presentation/view/pages/setting_notification_screen.dart`

For every new notification type:

- Add a key in `NotificationKeys`.
- Add a seed in `NotificationSettingsSeeder`.
- Add title/body/channel mapping in `NotificationDataConst`.
- Pass `settingKey` whenever showing or scheduling the notification.
- Respect the master key `ISNOTIFY`.
- Use `NotificationService` or the notification orchestrator.
- Do not instantiate a separate notification plugin.

Notification channel rules:

- Android channel display names must keep the localized Tamaneena app prefix.
- Android channel IDs are effectively permanent after creation by the system.
  If sound/importance changes, create a new channel ID version.
- Existing Android sound resources are in `android/app/src/main/res/raw`.
- Existing iOS athan sound is `ios/Runner/athan.caf`.

Athan rules:

- Android athan uses `NotificationChannel.athan`.
- Android athan sound resource is `athan`.
- iOS athan must pass `iosSound: 'athan.caf'`.
- Athan can use `InterruptionLevel.timeSensitive` where appropriate.
- Do not bypass DND or use full-screen intent without a clear policy reason.

## Exact Alarms

The app currently declares:

- `SCHEDULE_EXACT_ALARM`

This supports accurate prayer/athan scheduling and related time-sensitive
features. Do not remove it casually.

Rules:

- Do not use `USE_EXACT_ALARM` unless the app clearly qualifies under Google
  Play policy as an alarm/calendar style app and the release strategy accepts
  that risk.
- If exact alarm permission is unavailable, keep a safe fallback such as
  `inexactAllowWhileIdle`.
- Do not break Fajr companionship, athan, prayer silent mode, or scheduled
  reminders while changing alarm behavior.

## Prayer Times

Core files:

- `lib/features/prayer_time/presentation/bloc/prayer_time_bloc.dart`
- `lib/features/prayer_time/presentation/view/pages/prayer_time_screen.dart`
- `lib/features/prayer_time/presentation/view/pages/prayer_time_settings_screen.dart`
- `lib/features/prayer_time/data/remote/prayer_time_repo.dart`
- `lib/features/prayer_time/data/database/database_coordinates_service.dart`
- `lib/features/prayer_time/data/service/athan_alarm_notification_router_service.dart`
- `lib/features/prayer_time/data/service/athan_alarm_payload_service.dart`

Rules:

- Prayer times depend on saved/manual/current location and UTC offset.
- `PrayerTimeBloc` refreshes when the app resumes.
- Prayer changes should refresh home widgets.
- Do not silently change calculation method or madhab.
- Location permission must only be requested in the relevant prayer/qibla flow.

## Prayer Silent Mode

Android implementation:

- `lib/features/prayer_time/data/service/prayer_silent_mode_native_service.dart`
- `lib/features/prayer_time/data/service/prayer_silent_mode_settings_store.dart`
- `android/app/src/main/kotlin/.../PrayerSilentModeScheduler.kt`
- `android/app/src/main/kotlin/.../PrayerSilentModeReceiver.kt`
- `MainActivity.kt` method channel:
  `com.tamaneena.tamaneena_app/prayer_silent_mode`
- Android permission: `ACCESS_NOTIFICATION_POLICY`

Android can change ringer mode if the user grants Notification Policy access.
Do not ask for this on startup. Ask only from prayer time settings when the
user enables the feature.

iOS cannot programmatically enable silent mode or Focus mode. The accepted iOS
alternative is notification reminders that tell the user to enable silent/focus
and later return to normal.

Never present the Android silent-mode flow as if it works on iOS.

## Floating Adhkar

Android implementation:

- `flutter_overlay_window`
- `SYSTEM_ALERT_WINDOW`
- overlay entrypoint in `main.dart`
- feature folder: `lib/features/floating_adhkar`

iOS limitation:

- iOS does not allow app-owned floating overlays above other apps.
- The accepted iOS alternative is notification-based reminders.

Rules:

- Do not request overlay permission on app launch.
- Request overlay permission only inside the floating adhkar Android flow.
- Do not attach overlay permission to athan or normal notifications.
- Any notification fallback must obey notification settings.

## Home And Lock Screen Widgets

Core service:

- `lib/core/home_widgets/home_widgets_service.dart`

Android widgets:

- `android/app/src/main/kotlin/.../HomeWidgets.kt`
- XML providers in `android/app/src/main/res/xml`
- layouts in `android/app/src/main/res/layout`
- drawables in `android/app/src/main/res/drawable`
- widget providers in `AndroidManifest.xml`

iOS widgets:

- `ios/TamaneenaWidgets/TamaneenaWidgets.swift`

Shared App Group:

- `group.com.tamaneena.tamaneena_app.widgets`

Current widget types:

- next prayer
- prayer times
- random dhikr
- random ayah
- daily wird
- iOS lock screen prayer/dhikr/ayah widgets

Rules:

- Android may request pinning if supported by the launcher.
- iOS cannot pin widgets from the app; the user adds them through the system.
- Widget UI must be very compact and use the app colors.
- Random ayah must use `quran_library`/`QuranCtrl`, not hard-coded ayah lists
  except fallback.
- Prayer widgets must update at prayer boundaries and not remain stuck on the
  first prayer.
- Background updates use `workmanager`; iOS plugin registrant callbacks must
  stay registered in `AppDelegate.swift`.

## Quran Content

Use the local Quran package:

- `flutter_packages/quran_library`

Important package facts:

- Package name: `quran_library`
- Current local package version: `4.2.0`
- It provides Quran display, Quran data, fonts, tafsir/translation assets,
  audio controllers, and related utilities.

Rules:

- Use Quran data from `quran_library` whenever possible.
- Do not create static ayah lists as primary data.
- Keep Quran text accurate. Do not edit ayah wording manually.
- Ensure `QuranLibrary.init()` is available before reading Quran package data,
  including in background/widget flows.
- Use appropriate Quran fonts for Quran display only.

## Daily Wird And Quran Plans

Relevant folders:

- `lib/features/daily_wird`
- `lib/features/quran_plan`

Rules:

- These features schedule reminders; wire new reminders through
  notification settings.
- Keep progress and session UI focused on the next user action.
- Avoid dense explanatory cards.
- When modifying infinite/loaded session lists, keep scroll controllers and
  pagination checks intact.
- Use `RequestState` helpers where the feature already uses them.

## Young Muslim

Relevant folder:

- `lib/features/young_muslim`

Rules:

- Keep children content clear, friendly, and light.
- Do not restore the removed playlist named "Behind the series" / equivalent
  old backstage playlist. It was intentionally removed as low value.
- Keep asset tests passing:
  `test/features/young_muslim/young_muslim_assets_test.dart`
- Do not add broken playlist references.

## Smart Outreach / Fajr Companionship

Relevant files:

- `lib/features/smart_outreach`
- `android/app/src/main/kotlin/.../smartoutreach/autodialer`
- `MainActivity.kt` method channel:
  `com.tamaneena.tamaneena_app/smart_outreach`
- `ios/Runner/AppDelegate.swift` smart outreach channel

Android behavior:

- Native scheduler and foreground phone-call service can trigger call flows.
- Uses contact/call/phone-state related permissions.
- Has battery optimization handling.

iOS behavior:

- iOS does not allow silent SMS or the same automatic calling behavior.
- iOS schedules notifications and can open the phone dialer for the user.

Rules:

- Do not break the existing Android Fajr companionship flow.
- Do not request call/contact permissions on startup.
- Request sensitive permissions only when the user enables or uses the feature.
- Keep iOS behavior as an explicit alternative, not a fake Android clone.
- Smart outreach notifications must be controllable from notification settings.

## Remote Config

Version/update Remote Config:

- `app_latest_version`
- `app_minimum_version`
- `app_download_url`
- `app_google_play_url`
- `app_release_notes`
- `app_update_priority`
- `app_download_size`

Social links Remote Config:

- `app_social_telegram_url`
- `app_social_whatsapp_url`
- `app_social_facebook_url`
- `app_social_instagram_url`
- `app_social_twitter_url`

Social link rules:

- `SocialLinksService` caches links for 30 days.
- Telegram has a fallback URL.
- Empty remote values mean the platform should appear disabled/gray and not be
  tappable.

Developer info rules:

- Developer information is hard-coded, not Remote Config.
- Developer name: Moatasem Alhilali.
- Website: `https://moatasem.dev`.
- WhatsApp may be a button/link, but do not display the phone number as visible
  text in compact developer sections.

Update UX rules:

- Android update sheet can show Telegram, MediaFire/app download URL, and
  Google Play when `app_google_play_url` is non-empty.
- iOS update UX should show App Store only.
- Apply the same update-option behavior from home and settings/version pages.

## Settings And App Info Pages

Relevant files:

- `lib/features/setting/presentation/view/pages/setting_screen.dart`
- `lib/features/setting/presentation/view/pages/app_information_pages.dart`

Current settings sections include:

- notification settings
- download settings
- version management
- about app
- privacy policy
- data safety
- developer info
- social links from Remote Config
- theme mode

Rules:

- Settings sections should stay small and unobtrusive.
- Use compact cards/chips.
- Developer compact card should show the developer name and icon buttons only.
- Do not expose the developer phone number as normal visible text in compact
  settings.

## Version Management

Relevant files:

- `lib/features/manage_version`
- `lib/src/core/update`

Rules:

- Keep version management cards compact and aligned with app style.
- Manual update checks may force Remote Config refresh.
- Offline automatic checks should fail gracefully.
- Do not show empty download options.
- Preserve Android/iOS platform-specific options.

## Android Permissions

Current manifest contains sensitive permissions. Treat each one as intentional
only when tied to a feature:

- Storage: legacy/download support. Keep max SDK constraints.
- `FOREGROUND_SERVICE`, `FOREGROUND_SERVICE_MEDIA_PLAYBACK`: audio/download
  service behavior.
- `FOREGROUND_SERVICE_PHONE_CALL`: smart outreach call manager.
- `FOREGROUND_SERVICE_SPECIAL_USE`: floating adhkar overlay service.
- `SCHEDULE_EXACT_ALARM`: prayer/athan/time-sensitive schedules.
- `POST_NOTIFICATIONS`: Android 13+ notifications.
- `ACCESS_NOTIFICATION_POLICY`: Android prayer silent mode.
- `WAKE_LOCK`, `RECEIVE_BOOT_COMPLETED`: scheduled notifications/services.
- `ACCESS_FINE_LOCATION`, `ACCESS_COARSE_LOCATION`: prayer times, qibla,
  travel/location features.
- `CALL_PHONE`, `READ_PHONE_STATE`, `ANSWER_PHONE_CALLS`, `READ_CONTACTS`:
  smart outreach/Fajr companionship.
- `REQUEST_IGNORE_BATTERY_OPTIMIZATIONS`: smart outreach scheduling reliability.
- `SYSTEM_ALERT_WINDOW`: Android floating adhkar only.

Rules:

- Do not add `SMS`, `CAMERA`, `MANAGE_EXTERNAL_STORAGE`, or install-package
  permissions unless a current feature truly requires them and Play policy is
  addressed.
- Do not show manufacturer permission screens on startup.
- Do not let a permission screen block app launch.
- Permission prompts must be feature-driven and explain why the permission is
  needed.

## Google Play Policy Sensitivity

Sensitive areas:

- exact alarms
- full-screen intents
- special-use foreground services
- phone-call foreground services
- overlay permission
- contacts/phone permissions
- notification policy access

Before changing these:

- Verify the feature still needs the permission.
- Avoid broad permissions when narrower behavior works.
- Keep user-facing justification clear.
- Keep Google Play declaration answers aligned with actual behavior.
- Never add a permission because it "might help".

## iOS Platform Limits

iOS does not allow:

- app-controlled floating overlays above other apps
- programmatically turning the device silent
- programmatically controlling Focus mode
- silently sending SMS
- the same automatic phone-call behavior as Android
- app-initiated widget pinning
- Android-style exact alarm permissions

Accepted alternatives:

- notification reminders
- lock screen widgets
- home screen widgets
- opening the phone dialer with user action
- concise in-app guidance

Do not hide these limitations in code. Make platform-specific behavior explicit
and graceful.

## Background Work

Background-related areas:

- `workmanager`
- `home_widget`
- Flutter local notification background callbacks
- Firebase Messaging background handler
- Android boot receivers
- iOS plugin registrant callbacks

Rules:

- Background callbacks must be top-level or entry-point annotated when required.
- Initialize cache/Quran data in background flows before reading them.
- Do not assume all plugins are available in background isolates.
- Keep iOS plugin registrant callbacks in `AppDelegate.swift`.
- Keep Android receivers exported only when required.

## Audio

Relevant packages:

- `just_audio`
- `audio_service` through Quran package/native activity
- `flutter_downloader`

Rules:

- Do not change `MainActivity` base class casually; it extends
  `AudioServiceActivity`.
- Android notification sounds are raw resources without extensions when passed
  to `RawResourceAndroidNotificationSound`.
- iOS notification sounds need the file name including extension.
- Quran audio and app notification audio are separate concerns.

## Downloads

Relevant areas:

- `lib/features/download`
- `lib/core/services/download_service.dart`
- `flutter_downloader` providers in Android manifest

Rules:

- Keep Flutter Downloader initialization.
- Keep provider paths and downloader initializer intact.
- Do not request broad storage permissions for modern Android unless the
  feature truly requires it.

## Data Safety And Privacy

Privacy/data pages are inside settings and should stay consistent with actual
permissions and behavior.

If permissions or data usage change:

- Update the in-app privacy/data safety pages.
- Update Play Console/App Store declarations as needed.
- Avoid claiming the app does not use data that a feature actually accesses.

## Tests And Verification

Useful commands:

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
flutter test test/features/floating_adhkar/floating_adhkar_selector_test.dart
flutter test test/features/young_muslim/young_muslim_assets_test.dart
flutter build apk --release --split-per-abi
flutter build appbundle --release
flutter build ios --release
```

Run verification based on risk:

- Dart-only UI/data change: `flutter analyze`
- logic change with tests: targeted `flutter test ...`
- notification scheduling change: inspect pending schedules and platform
  details where possible
- Android native/manifest change: Android build or at least Gradle/Flutter
  build if available
- iOS widget/AppDelegate change: iOS build if available
- widget data change: verify Android provider names and iOS widget kind names

Do not claim a platform feature works if you could not verify it and the change
is risky.

## Lints And Code Style

The project uses strict analysis settings:

- strict casts
- strict inference
- strict raw types
- many lints from Flutter/Very Good style

Code style expectations:

- single quotes in Dart
- prefer `final`
- prefer `const`
- trailing commas
- package imports, not relative `lib` imports
- no `print`; use `logger` or `debugPrint` as appropriate
- avoid long lines where practical
- handle `BuildContext` after `await` with `context.mounted`
- use `unawaited(...)` for intentionally unawaited futures

## Feature Addition Checklist

When adding a feature:

1. Locate the closest existing feature pattern.
2. Choose platform behavior for Android and iOS separately.
3. Add state management only if the feature has real state.
4. Use existing theme extensions and `AppIcon`.
5. Keep UI compact and RTL-friendly.
6. Route notifications through notification settings.
7. Add Remote Config defaults and cache if using Remote Config.
8. Add permission prompts only inside the relevant feature path.
9. Add fallback/error states.
10. Run appropriate verification.

## UI Redesign Checklist

When redesigning an existing page:

1. Preserve the feature's behavior.
2. Keep the page's main action obvious.
3. Use compact cards and clear hierarchy.
4. Use small icons with proper inner padding.
5. Avoid nested scroll errors.
6. Check Arabic text overflow.
7. Keep the same dark/gold app identity.
8. Do not add explanatory text about how the UI works.
9. Do not broaden the scope into unrelated pages.

## Notification Addition Checklist

For each new notification:

1. Add `NotificationKeys` key.
2. Add seed entry.
3. Add title/body mapping.
4. Add channel mapping.
5. Pass `settingKey`.
6. Use stable notification IDs or `NotificationIdManager`.
7. Add Android/iOS sound details if needed.
8. Respect `ISNOTIFY`.
9. Cancel/reschedule correctly when disabled.

## Widget Addition Checklist

For each new home/lock widget:

1. Add data writes in `HomeWidgetsService`.
2. Add Android provider/layout/XML if Android widget.
3. Add iOS WidgetKit kind/view if iOS widget.
4. Add kind/provider to update lists.
5. Keep App Group and keys consistent.
6. Keep design tiny and readable.
7. Add background refresh if data changes over time.
8. Provide safe fallback data.

## Platform-Specific Decision Rules

Use this decision tree:

- If Android supports the behavior and iOS does not, implement Android and an
  honest iOS alternative.
- If the behavior requires a sensitive permission, request it only inside the
  feature.
- If a platform API cannot guarantee the behavior, show a reminder or manual
  action instead of pretending it is automatic.
- If Google Play policy is likely to reject it, reduce scope or document the
  declaration path before shipping.

## Known Fragile Areas

Be especially careful with:

- notification channels and sound IDs
- exact alarm permission
- `PrayerTimeBloc` refresh/reschedule behavior
- `HomeWidgetsService` background refresh and App Group keys
- `AppDelegate.swift` plugin registration
- Android `MainActivity.kt` method channels
- smart outreach permissions/services
- floating adhkar overlay permission
- nested scroll views in `AppScaffoldWidget`
- icon sizing inside containers
- Quran data initialization in background

## Do Not Do

- Do not recreate or rely on `QWEN.md`.
- Do not use hard-coded Quran ayah lists as primary data.
- Do not add startup permission gates.
- Do not request overlay/DND/call/contact permissions outside their features.
- Do not remove `SCHEDULE_EXACT_ALARM` without a full feature and policy
  review.
- Do not make iOS execute impossible Android-only behavior.
- Do not use large default Material icons in new UI.
- Do not leave new notifications outside settings control.
- Do not introduce broad Android permissions without a current feature need.
- Do not revert user changes or dirty files unrelated to the task.


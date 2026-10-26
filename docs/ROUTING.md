# Routing — auto_route conventions

This app uses [`auto_route`](https://pub.dev/packages/auto_route) **11.1.0** with
`auto_route_generator` pinned to `>=10.4.0 <10.6.0`.

> The pin is deliberate: `auto_route_generator` 10.6.0+ pulls `lean_builder`,
> which requires Dart >= 3.12, while this project is on 3.11.5. Do not bump it
> without also moving the SDK floor.

Most auto_route material online targets v7/v8 and **will not compile** here.
See [Removed APIs](#removed-apis-v11) before copying anything from a blog post.

---

## Where routes live

Routes are declared **per feature**, never in one central list.

```
lib/
  core/router/
    app_router.dart              # @AutoRouterConfig — composes feature routes only
    app_router.gr.dart           # generated, never edited by hand
    app_route_transitions.dart   # shared RouteType definitions
    analytics_screen_names.dart  # Firebase screen-name mapping
  features/
    <feature>/
      <feature>_routes.dart      # this feature's List<AutoRoute>
      presentation/view/pages/…  # the screens, annotated with @RoutePage()
```

Each feature exposes one class:

```dart
// lib/features/quran_plan/quran_plan_routes.dart
import 'package:auto_route/auto_route.dart';
import 'package:quran_app/core/router/app_router.gr.dart';

abstract final class QuranPlanRoutes {
  static List<AutoRoute> get routes => [
        AutoRoute(path: '/plans', page: QuranPlanListRoute.page),
        AutoRoute(path: '/plans/new', page: QuranPlanAddRoute.page),
        AutoRoute(path: '/plans/:planId', page: QuranPlanSessionRoute.page),
      ];
}
```

and the root router only composes:

```dart
@override
List<AutoRoute> get routes => [
      ...HomeRoutes.routes,
      ...QuranPlanRoutes.routes,
      ...ThikrRoutes.routes,
      // …
      AutoRoute(path: '*', page: NotFoundRoute.page), // must stay last
    ];
```

**Adding a screen** means touching exactly two files: the screen (add
`@RoutePage()`) and its feature's `_routes.dart`. Never the root router, unless
the feature itself is new.

---

## Path rules

Paths are **always explicit**. If you omit one, auto_route derives it from the
class name (`BookListPage` → `book-list-page`), which leaks Dart naming into
public deep links and is painful to change later.

**Paths are ASCII slugs, in English, kebab-case.** Arabic stays in the UI layer
and the data layer, never in a URL:

```dart
AutoRoute(path: '/athkar/morning', page: MorningAthkarRoute.page)   // correct
AutoRoute(path: '/athkar/أذكار-الصباح', page: MorningAthkarRoute.page) // WRONG
```

A non-ASCII segment arrives percent-encoded (`%D8%A3%D8%B0...`), so the raw
segment auto_route matches against is not the string you wrote.

Ordering matters inside the composed list:

- `/surah` must come before `/surah/:id`
- `AutoRoute(path: '*')` must be the very last entry or it swallows everything

---

## Annotating a screen

```dart
@RoutePage()
class QuranPlanSessionScreen extends StatefulWidget {
  const QuranPlanSessionScreen({super.key, required this.planId, this.title});
  final int planId;
  final String? title;
  …
}
```

The generated class name drops a `Page` **or** `Screen` suffix and appends
`Route`, because `replaceInRouteName` defaults to `'Page|Screen,Route'`:

| Widget | Generated route |
| --- | --- |
| `QuranPlanSessionScreen` | `QuranPlanSessionRoute` |
| `SettingPage` | `SettingRoute` |
| `TasbeehProvider` | `TasbeehProviderRoute` |

Renaming a widget renames its route class and breaks every call site, so rename
deliberately.

After any annotation or route change:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Path and query parameters

```dart
@RoutePage()
class SurahScreen extends StatelessWidget {
  const SurahScreen({
    super.key,
    @PathParam('id') required this.surahId,
    @QueryParam('ayah') this.ayah,          // MUST be nullable or have a default
  });
  final int surahId;
  final int? ayah;
}
```

A non-nullable `@QueryParam` without a default fails the moment a link omits it.

---

## Screens that need a BLoC

Do **not** push `BlocProvider.value(value: bloc, child: Screen())`. auto_route
generates the route from the *screen's* constructor, so a bloc passed from the
caller cannot travel with a deep link or survive a guard re-push.

Use `AutoRouteWrapper` and resolve the bloc from `get_it` (`sl<…>`):

```dart
@RoutePage()
class QuranPlanAddScreen extends StatelessWidget implements AutoRouteWrapper {
  const QuranPlanAddScreen({super.key});

  @override
  Widget wrappedRoute(BuildContext context) =>
      BlocProvider<QuranPlanBloc>(create: (_) => sl<QuranPlanBloc>(), child: this);

  …
}
```

If two screens must share one bloc instance, register it as a singleton in
`service_locator.dart` rather than handing the instance between routes.

---

## Navigating

```dart
context.router.push(const QuranPlanListRoute());        // add to the stack
context.router.push(QuranPlanSessionRoute(planId: 3));  // typed args
context.router.pushPath('/plans/3');                    // by path
context.router.navigate(const HomeRoute());             // pop-to-existing, else push
context.router.replaceAll([const HomeRoute()]);         // reset the stack

await context.router.maybePop();                        // respects PopScope
context.router.pop(result);                             // FORCED pop
```

### `pop()` changed meaning — read this

In auto_route v10+, **`pop()` is the forced pop** (the old `popForced`) and
**`maybePop()` is the polite one** that respects `PopScope`.

The old `Navigator.pop(context)` behaved like `maybePop`. A blind
find-and-replace of `Navigator.pop` → `context.router.pop` silently disables
every `PopScope` guard in the app. When migrating a `pop`, ask which you want.

For dismissing a dialog or bottom sheet, keep using `Navigator.pop(context)` —
see below.

### `context.router` is scoped

Inside a nested router, `context.router` is the *inner* controller, not the
root. Use `context.router.root` when you deliberately want the top-level stack.

---

## Removed APIs (v11)

These no longer exist and will not compile:

| Removed | Use instead |
| --- | --- |
| `pushNamed` | `pushPath` |
| `replaceNamed` | `replacePath` |
| `navigateNamed`, `navigateNamedTo` | `navigatePath` |
| `popForced` | `pop` |
| `resolver.redirect(...)` | `resolver.redirectUntil(...)` |
| `@AutoRouterConfig.module` | plain Dart composition (see above) |
| `@RoutePage<bool>()` | give the type at the push site: `push<bool>(…)` |
| `extends $AppRouter` | `extends RootStackRouter` |

---

## What stays on the raw `Navigator`

auto_route models *pages*. These are not pages and must keep using `Navigator`:

- `showDialog`, `showGeneralDialog`, `showModalBottomSheet` (27 call sites)
- `ModalSheetRoute` from `smooth_sheets` (`extension_sheet.dart`)
- everything inside the vendored `quran_library` package, which uses GetX with
  its own navigator key

Because these are pageless, `popUntilRouteWithName` does not see them and a deep
link cannot restore them.

> ⚠️ Bottom sheets opened with `useRootNavigator: true` (8 files under
> `lib/core/components/`) resolve against the root navigator. If a nested router
> is ever introduced, a `Navigator.pop` inside such a sheet will target a
> different navigator and the sheet will not close. Keep the `pop` that closes a
> sheet paired with the `show…` that opened it.

---

## Transitions

The default route type is a 250 ms fade (`AppRouteTransitions.fade`), matching
the old `fadeNavigation` helper so the app feels unchanged. Do not accept the
Material default — it is a visible regression.

Per-route override:

```dart
CustomRoute(
  path: '/young-muslim/video/:videoId',
  page: YoungMuslimVideoDetailsRoute.page,
  transitionsBuilder: AppRouteTransitions.youngMuslimTransition,
  durationInMilliseconds: 260,
)
```

---

## Analytics

`FirebaseAnalyticsObserver` records `RouteSettings.name`, which auto_route sets
to the route class name (`PrayerTimeRoute`). Historical dashboards use the old
widget names (`PrayerTimeScreen`), so `analytics_screen_names.dart` maps
`XRoute` → `XScreen` and holds explicit aliases for screens that were reported
under a custom name.

**When you add a screen whose analytics name should not be `<class>Screen`, add
an alias there.** Otherwise nothing to do.

---

## Deep links

Public domain: `tamaneena.app`. The admin console (`orbit.tamaneena.app`) is
deliberately **not** registered — on Android 11 and below a single unverifiable
host fails verification for the whole app.

- Android App Links: `android/app/src/main/AndroidManifest.xml`
- iOS Universal Links: `ios/Runner/Runner.entitlements`
- Custom scheme fallback: `tamaneena://app/...`

The `assetlinks.json` fingerprint must be the **Play app signing key**, not the
upload key — see `docs/DEEP_LINKS.md`.

`flutter_deeplinking_enabled` is **not** set anywhere: Flutter's built-in
handling has been the default since 3.27 and auto_route relies on it. Adding a
third-party deep-link plugin means disabling it on both platforms, so don't.

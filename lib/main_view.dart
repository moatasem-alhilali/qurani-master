import 'dart:async';

import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:auto_route/auto_route.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/bloc/locale/locale_cubit.dart';
import 'package:quran_app/core/bloc/base/base_bloc.dart';
import 'package:quran_app/core/bloc/connectivity/connectivity_bloc.dart';
import 'package:quran_app/core/bloc/device_sync/device_sync_bloc.dart';
import 'package:quran_app/core/bloc/theme/theme_bloc.dart';
import 'package:quran_app/core/router/app_router.dart';
import 'package:quran_app/core/device_sync/data/device_sync_repository.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/notification/bloc/notification_bloc.dart';
import 'package:quran_app/core/services/firebase_monitoring.dart';
import 'package:quran_app/core/services/navigation_service.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/features/ayah_reminder/data/ayah_reminder_router_service.dart';
import 'package:quran_app/features/ayah_reminder/data/ayah_reminder_scheduler.dart';
import 'package:quran_app/core/util/dark_theme.dart';
import 'package:quran_app/core/util/exit_alert.dialog.dart';
import 'package:quran_app/core/util/light_theme.dart';
import 'package:quran_app/features/daily_wird/data/repo/daily_wird_repository.dart';
import 'package:quran_app/features/home/presentation/bloc/random_ayah_bloc.dart';
import 'package:quran_app/features/home_widgets/presentation/home_widget_click_router.dart';
import 'package:quran_app/features/language/presentation/language_picker_screen.dart';
import 'package:quran_app/features/onboarding/presentation/onboarding_cubit.dart';
import 'package:quran_app/features/onboarding/presentation/permissions_onboarding_screen.dart';
import 'package:quran_app/l10n/l10n.dart';
import 'package:quran_app/features/prayer_time/data/database/database_coordinates_service.dart';
import 'package:quran_app/features/prayer_time/data/remote/prayer_time_repo.dart';
import 'package:quran_app/features/prayer_time/data/service/athan_alarm_notification_router_service.dart';
import 'package:quran_app/features/prayer_time/presentation/bloc/prayer_time_bloc.dart';
import 'package:quran_app/features/radio/presentation/bloc/radio_bloc.dart';
import 'package:quran_app/src/core/review/app_review_service.dart';
import 'package:quran_app/src/core/update/app_update_cubit.dart';
import 'package:quran_app/src/core/update/app_update_service.dart';
import 'package:quran_app/src/core/update/update_prompts.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /// الموجّه يُنشأ مرّة واحدة ويُحفظ كحقل.
  ///
  /// إنشاؤه داخل `build` يعيد بناء المكدّس كلّه في كل إطار — وهو الفخّ الأوّل
  /// الذي يحذّر منه توثيق auto_route.
  ///
  /// يستلم `NavigationService.navigatorKey` نفسه الذي كان على `MaterialApp`،
  /// فيبقى كل ما يعتمد عليه يعمل — تهيئة `FToast` في `BaseBloc` مثلًا.
  late final AppRouter _appRouter = AppRouter(
    navigatorKey: NavigationService.navigatorKey,
  );

  late final RouterConfig<UrlState> _routerConfig = _appRouter.config(
    // يسجّل كل شاشة يُنتقل إليها في Analytics باسم مسارها.
    navigatorObservers: () => FirebaseMonitoring.navigatorObservers,
    deepLinkTransformer: _transformDeepLink,
  );

  /// يُعالج الرابط الخام قبل مطابقته بالمسارات.
  ///
  /// منذ auto_route 8 لم تعد الروابط بلا مضيف تُعالَج تلقائيًا: Flutter يقرأ
  /// `tamaneena://app/quran` على أن المضيف `app` والمسار `/quran`، فنعيد ضمّ
  /// المضيف إلى أوّل المسار. وروابط لوحة التحكّم لا تخصّ التطبيق فتُردّ إلى
  /// الرئيسية بدل أن تفتح شاشة فارغة.
  static Future<Uri> _transformDeepLink(Uri uri) async {
    if (uri.host == 'orbit.tamaneena.app') {
      return Uri.parse('/');
    }

    if (uri.scheme == 'tamaneena' && uri.host.isNotEmpty) {
      if (uri.host == 'widget') {
        // ودجت الشاشة الرئيسية تصل عبر قناة home_widget لا عبر الموجّه.
        return Uri.parse('/');
      }
      return uri.replace(
        scheme: 'https',
        host: 'tamaneena.app',
        path: '/${uri.host}${uri.path}',
      );
    }

    return uri;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        ///prayer time
        BlocProvider(
          create: (context) => PrayerTimeBloc(
            prayerTimeService: AdhanPrayerTimeService(),
            coordinatesService: DatabaseCoordinatesService(),
          ),
        ),

        ///connectivity
        BlocProvider(
          create: (context) =>
              sl<ConnectivityBloc>()..add(const ConnectivityStarted()),
          lazy: false,
        ),

        BlocProvider(
          create: (context) => DeviceSyncBloc(
            repository: sl<DeviceSyncRepository>(),
            connectivityBloc: context.read<ConnectivityBloc>(),
          )..add(const DeviceSyncStarted()),
          lazy: false,
        ),

        ///theme
        BlocProvider(
          create: (context) => ThemeBloc()..add(InitThemeEvent()),
        ),

        // ///quran audio
        // BlocProvider(
        //   create: (context) =>
        //       sl<QuranAudioBloc>()..add(InitQuranPlayerDataEvent()),
        //   lazy: false,
        // ),

        ///base
        BlocProvider(create: (context) => BaseBloc()),

        // ///bookmark
        // BlocProvider(
        //   create: (context) => sl<BookmarkBloc>()
        //     ..add(GetBookmarksAyahEvent())
        //     ..add(GetBookmarksPageEvent()),
        //   lazy: false,
        // ),

        // BlocProvider(
        //   lazy: false,
        //   create: (context) => ReadQuranBloc()
        //     ..add(LoadQuranEvent())
        //     ..add(GetLastPageReadEvent()),
        // ),

        ///notification
        BlocProvider(
          create: (context) =>
              NotificationBloc()..add(InitializeNotificationEvent()),
          lazy: false,
        ),

        ///home
        BlocProvider(
          create: (context) => sl<RandomAyahBloc>()..add(GetRandomAyahEvent()),
          lazy: false,
        ),
        BlocProvider(
          create: (context) => sl<RadioBloc>()..add(const RadioInitialized()),
          lazy: false,
        ),
        BlocProvider(
          create: (context) => AppUpdateCubit(),
          lazy: false,
        ),

        ///language — يُنشأ أوّلًا فعليًا: MaterialApp يقرأ لغته منه.
        BlocProvider(
          create: (context) => LocaleCubit(),
          lazy: false,
        ),

        ///onboarding — شاشات الصلاحيات مرّة واحدة بعد اللغة.
        BlocProvider(
          create: (context) => OnboardingCubit(),
          lazy: false,
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          final localeState = context.watch<LocaleCubit>().state;
          final permissionsDone = context.watch<OnboardingCubit>().state;
          return BlocBuilder<ConnectivityBloc, ConnectivityState>(
            builder: (context, state) {
              return ScreenUtilInit(
                minTextAdapt: true,
                splitScreenMode: true,
                builder: (_, child) => MaterialApp.router(
                  // اللغة من LocaleCubit وحده. اتّجاه الواجهة (يمين/يسار)
                  // يتبعها تلقائيًا عبر GlobalWidgetsLocalizations.
                  locale: localeState.locale,
                  localizationsDelegates: L10n.localizationsDelegates,
                  supportedLocales: L10n.supportedLocales,
                  routerConfig: _routerConfig,
                  // // darkTheme: getDarkMode(),
                  // darkTheme: context.themeApp,
                  // theme: getLightMode(),
                  darkTheme: darkTheme,
                  theme: lightTheme,
                  themeMode: themeState.currentThemeMode,
                  onGenerateTitle: (context) => context.l10n.appName,
                  themeAnimationCurve: Curves.decelerate,
                  themeAnimationDuration: const Duration(milliseconds: 300),
                  themeAnimationStyle: const AnimationStyle(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.decelerate,
                    reverseCurve: Curves.decelerate,
                    reverseDuration: Duration(milliseconds: 300),
                  ),
                  debugShowCheckedModeBanner: false,
                  builder: (context, child) {
                    // أوّل فتح: اللغة، ثم الإشعارات والموقع — مرّة واحدة لكلٍّ.
                    //
                    // البوّابة هنا لا داخل جدول المسارات: التهيئة ليست وجهةً
                    // يُنتقل إليها بل حاجزٌ يُعبر مرّة. وهذا يجعل الرابط
                    // العميق الواصل أثناء التهيئة ينتظر خلف الحاجز — الموجّه
                    // يكون قد وصل إليه فعلًا — فيظهر فور انتهائها بدل أن
                    // يضيع.
                    final Widget content;
                    if (!localeState.confirmed) {
                      content = const LanguagePickerScreen(isOnboarding: true);
                    } else if (!permissionsDone) {
                      content = const PermissionsOnboardingScreen();
                    } else {
                      content = _AppShell(
                        child: child ?? const SizedBox.shrink(),
                      );
                    }

                    return DevicePreview.appBuilder(context, content);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// الغلاف الدائم حول مخرجات الموجّه.
///
/// كان اسمه `_App` وكان هو **الشاشة الرئيسية نفسها**: يرسم
/// `Scaffold(body: HomeScreenNew())`. بعد الترحيل صارت الرئيسية مسارًا
/// (`HomeRoute`)، فبقي هنا ما يجب أن يعيش فوق المكدّس كلّه ولا يُعاد بناؤه مع
/// كل انتقال: مراقبة دورة حياة التطبيق، فحص التحديثات، تأكيد الخروج، وربط
/// موجّهَي الإشعار والودجت.
class _AppShell extends StatefulWidget {
  const _AppShell({required this.child});

  /// المكدّس الذي يبنيه الموجّه.
  final Widget child;

  @override
  State<_AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<_AppShell> with WidgetsBindingObserver {
  /// هل تنبيه تحديث iOS معروض الآن؟
  ///
  /// الفحص صار يجري عند الرجوع للتطبيق أيضًا، فلو ترك المستخدم التنبيه مفتوحًا
  /// ورجع بعد ساعات لا يُفتح تنبيه ثانٍ فوقه.
  bool _isIosUpdateDialogOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    sl<AthanAlarmNotificationRouterService>().initialize();
    sl<AyahReminderRouterService>().initialize();
    unawaited(sl<DailyWirdRepository>().syncReminderSchedules());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      unawaited(context.read<AppUpdateCubit>().checkForUpdate());
      unawaited(_maybeAskForReview());
      // ضغطة على ودجت (والتطبيق مغلق أو في الخلفية) تفتح الشاشة المقصودة.
      HomeWidgetClickRouter.attach();
    });
  }

  /// Fires the native in-app review at a calm, post-launch moment for engaged
  /// users. The heavy lifting (eligibility, OS throttling, connectivity) lives
  /// in [AppReviewService]; here we only add a small delay to let the launch
  /// settle, and yield priority to an update prompt if one is about to show.
  Future<void> _maybeAskForReview() async {
    await Future<void>.delayed(const Duration(seconds: 5));
    if (!mounted) return;

    final updateState = context.read<AppUpdateCubit>().state;
    if (updateState is AppUpdateIosAvailable && updateState.shouldPrompt) {
      return;
    }

    await AppReviewService().requestReviewIfAppropriate();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed || !mounted) {
      return;
    }

    // الآيفون يُرجِع التطبيق من الذاكرة بدل إقلاعه، ففحص الإقلاع وحده قد لا
    // يجري أيامًا. المكعّب يحدّه بمرّة كل 12 ساعة ويتجاهله على أندرويد.
    unawaited(context.read<AppUpdateCubit>().checkForUpdateOnResume());

    // ولِلسبب نفسه يُملأ طابور «آية اليوم» هنا: سبعة أيام تُستهلك يومًا بيوم،
    // ولو انتظر الإقلاع البارد لانقطع الإشعار عن مستخدم يفتح التطبيق كل يوم.
    // رخيص: إلغاء سبعة معرّفات وإعادة جدولتها.
    unawaited(sl<AyahReminderScheduler>().reschedule());

    final prayerBloc = context.read<PrayerTimeBloc>()
      ..add(const PrayerTimeRefreshOnAppResumeRequested());

    final currentState = prayerBloc.state;
    if (currentState.prayerState != RequestState.success ||
        currentState.nextPrayer == null) {
      prayerBloc.add(const PrayerTimeInitRequested());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scaffold = PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, res) async {
        if (didPop) {
          return;
        }

        // زرّ الرجوع يخدم حالتين: إغلاق الشاشة الحالية، أو الخروج من التطبيق
        // حين لا يبقى ما يُغلق. نسأل الموجّه أوّلًا — و`maybePop` هو المهذّب
        // الذي يحترم `PopScope` داخل الشاشات — فإن لم يبقَ شيء نعرض التأكيد.
        final popped = await context.router.maybePop();
        if (!popped && context.mounted) {
          showMyAlert(context: context);
        }
      },
      child: widget.child,
    );

    return BlocListener<AppUpdateCubit, AppUpdateStatus>(
      listenWhen: (previous, current) =>
          current is AppUpdateAndroidReady ||
          (current is AppUpdateIosAvailable && current.shouldPrompt),
      listener: (context, state) {
        // Android: a flexible update finished downloading — offer to install.
        if (state is AppUpdateAndroidReady) {
          AdaptiveSnackBar.show(
            context,
            message: context.l10n.coreUpdateDownloaded,
            type: AdaptiveSnackBarType.success,
            duration: const Duration(seconds: 8),
            action: context.l10n.coreUpdateInstallNow,
            onActionPressed: () =>
                context.read<AppUpdateCubit>().installAndroidUpdate(),
          );
          return;
        }

        // iOS: a newer App Store version exists — prompt to update.
        if (state is AppUpdateIosAvailable && !_isIosUpdateDialogOpen) {
          _isIosUpdateDialogOpen = true;
          unawaited(
            showIosUpdateDialog(
              context,
              storeVersion: state.storeVersion,
              storeUrl: state.storeUrl,
              releaseNotes: state.releaseNotes,
              onLater: () => context
                  .read<AppUpdateCubit>()
                  .skipIosVersion(state.storeVersion),
            ).whenComplete(() => _isIosUpdateDialogOpen = false),
          );
        }
      },
      child: scaffold,
    );
  }
}

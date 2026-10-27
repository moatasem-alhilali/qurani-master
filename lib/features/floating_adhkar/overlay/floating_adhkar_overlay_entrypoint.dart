import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quran_app/core/cash/cache_service.dart';
import 'package:quran_app/core/local_database/database_service.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/floating_adhkar/data/database/floating_adhkar_database_service.dart';
import 'package:quran_app/features/floating_adhkar/data/models/floating_adhkar_item.dart';
import 'package:quran_app/features/floating_adhkar/data/repo/floating_adhkar_repository.dart';
import 'package:quran_app/features/floating_adhkar/data/service/floating_adhkar_built_in_source.dart';
import 'package:quran_app/features/floating_adhkar/data/service/floating_adhkar_selector.dart';
import 'package:quran_app/features/floating_adhkar/overlay/floating_adhkar_overlay_coordinator.dart';
import 'package:quran_app/features/floating_adhkar/overlay/floating_adhkar_overlay_state.dart';
import 'package:quran_app/gen/fonts.gen.dart';
import 'package:quran_app/l10n/l10n.dart';

Future<void> runFloatingAdhkarOverlay() async {
  WidgetsFlutterBinding.ensureInitialized();
  // محرّك النافذة العائمة منفصل: نحمّل التخزين ليقرأ L10nService اللغة
  // المحفوظة (وإلا عاد إلى العربية).
  try {
    await CacheService.init();
  } catch (_) {}
  await DatabaseService().database;

  final repository = FloatingAdhkarRepository(
    databaseService: FloatingAdhkarDatabaseService(),
    builtInSource: FloatingAdhkarBuiltInSource(),
    selector: FloatingAdhkarSelector(),
  );

  runApp(
    FloatingAdhkarOverlayApp(
      coordinator: FloatingAdhkarOverlayCoordinator(
        repository: repository,
      ),
    ),
  );
}

class FloatingAdhkarOverlayApp extends StatefulWidget {
  const FloatingAdhkarOverlayApp({
    required this.coordinator,
    super.key,
  });

  final FloatingAdhkarOverlayCoordinator coordinator;

  @override
  State<FloatingAdhkarOverlayApp> createState() =>
      _FloatingAdhkarOverlayAppState();
}

class _FloatingAdhkarOverlayAppState extends State<FloatingAdhkarOverlayApp> {
  @override
  void initState() {
    super.initState();
    unawaited(widget.coordinator.initialize());
  }

  @override
  void dispose() {
    unawaited(widget.coordinator.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: L10n.localizationsDelegates,
      supportedLocales: L10n.supportedLocales,
      locale: L10nService.savedLanguage.locale,
      theme: _buildOverlayTheme(Brightness.light),
      darkTheme: _buildOverlayTheme(Brightness.dark),
      // نصّ الذكر عربي دائمًا، فيبقى اتجاهه من اليمين مهما كانت لغة الواجهة.
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: ValueListenableBuilder<FloatingAdhkarOverlayState>(
            valueListenable: widget.coordinator.notifier,
            builder: (context, state, child) {
              final item = state.currentItem;
              if (!state.visible || item == null) {
                return const SizedBox.shrink();
              }

              return Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(10, 5, 12, 7),
                child: _FloatingAdhkarCard(
                  // A new dhikr replays the entry and restarts the countdown.
                  key: ValueKey(item.id),
                  item: item,
                  visibleSeconds: state.settings?.visibleSeconds ?? 0,
                  onDismiss: widget.coordinator.dismissCurrent,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// الذكر كما يطفو فوق التطبيقات الأخرى.
///
/// The card fills the overlay window, which the coordinator resizes to an
/// estimated height before showing it — so the text area scrolls instead of
/// overflowing whenever that estimate falls short.
class _FloatingAdhkarCard extends StatelessWidget {
  const _FloatingAdhkarCard({
    required this.item,
    required this.visibleSeconds,
    required this.onDismiss,
    super.key,
  });

  final FloatingAdhkarItem item;
  final int visibleSeconds;
  final VoidCallback onDismiss;

  static const double _radius = 20;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final title = item.title.trim().isEmpty ? item.sourceLabel : item.title;

    return _EntryAnimation(
      child: DecoratedBox(
        decoration: BoxDecoration(
          // Opaque on purpose: the card sits over whatever app is underneath.
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color.alphaBlend(
                colorScheme.primary.withValues(alpha: 0.10),
                colorScheme.surface,
              ),
              colorScheme.surface,
            ],
          ),
          borderRadius: BorderRadius.circular(_radius),
          border: Border.all(
            color: colorScheme.primary.withValues(alpha: 0.22),
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.16),
              blurRadius: 20,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onDismiss,
            borderRadius: BorderRadius.circular(_radius - 1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _CardHeader(title: title, onClose: onDismiss),
                Divider(
                  height: 1,
                  thickness: 1,
                  indent: 12,
                  endIndent: 12,
                  color: colorScheme.outline,
                ),
                Flexible(
                  child: Center(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      child: Text(
                        item.text,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                  ),
                ),
                if (visibleSeconds > 0) _CountdownRail(seconds: visibleSeconds),
                const SizedBox(height: 9),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ظهور بلا قفزة: تلاشٍ وانسياب من الحافّة التي تعلّقت بها البطاقة.
class _EntryAnimation extends StatelessWidget {
  const _EntryAnimation({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset((1 - value) * 26, 0),
          child: Transform.scale(
            scale: 0.97 + 0.03 * value,
            child: child,
          ),
        ),
      ),
      child: child,
    );
  }
}

/// العنوان وزرّ الإغلاق: صفّ واحد نحيل فوق خطّ الشعرة.
class _CardHeader extends StatelessWidget {
  const _CardHeader({required this.title, required this.onClose});

  final String title;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 8, 6, 7),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: AppIcon(
                AppIcons.tasbih,
                color: colorScheme.primary,
                size: 12,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: colorScheme.primary,
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
          ),
          Semantics(
            button: true,
            label: context.l10n.commonClose,
            child: InkResponse(
              onTap: onClose,
              radius: 18,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: AppIcon(
                  AppIcons.close,
                  color: colorScheme.onSurfaceVariant,
                  size: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ما بقي من زمن الظهور — الإشارة الوحيدة أن البطاقة ستنسحب وحدها.
class _CountdownRail extends StatelessWidget {
  const _CountdownRail({required this.seconds});

  final int seconds;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: SizedBox(
        height: 2.5,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: ColoredBox(
            color: colorScheme.outline,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 1, end: 0),
              duration: Duration(seconds: seconds),
              builder: (context, value, child) => Align(
                alignment: AlignmentDirectional.centerStart,
                child: FractionallySizedBox(
                  widthFactor: value,
                  child: child,
                ),
              ),
              child: Container(
                height: 2.5,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.gold, AppColors.brandGoldLight],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

ThemeData _buildOverlayTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  final colorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.gold,
    brightness: brightness,
  ).copyWith(
    primary: AppColors.gold,
    secondary: AppColors.blue,
    // النافذة العائمة تعمل في محرّك منفصل بلا `BuildContext` للتطبيق، لكنها
    // تأخذ ألوانها من لوحة [AppSkin] الثابتة نفسها حتى لا تبدو غريبة عنه.
    surface: isDark ? AppSkin.dark.raised : AppSkin.light.raised,
    onSurface: isDark ? AppSkin.dark.ink : AppSkin.light.ink,
    onSurfaceVariant: isDark ? AppSkin.dark.inkSoft : AppSkin.light.inkSoft,
    outline: isDark ? AppSkin.dark.hairline : AppSkin.light.hairline,
    shadow: isDark ? AppColors.darkShadow : AppColors.shadow,
  );
  final base = ThemeData(
    brightness: brightness,
    useMaterial3: true,
    fontFamily: FontFamily.scheherazade,
  );

  return base.copyWith(
    scaffoldBackgroundColor: Colors.transparent,
    colorScheme: colorScheme,
    textTheme: base.textTheme.copyWith(
      titleLarge: base.textTheme.titleLarge?.copyWith(
        fontFamily: FontFamily.scheherazade,
        fontSize: 17.5,
        fontWeight: FontWeight.w600,
        height: 1.9,
        color: colorScheme.onSurface,
      ),
    ),
  );
}

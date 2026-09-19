import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quran_app/core/cash/cache_service.dart';
import 'package:quran_app/core/local_database/database_service.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/features/floating_adhkar/data/database/floating_adhkar_database_service.dart';
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

              final colorScheme = Theme.of(context).colorScheme;

              return Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: 10,
                    end: 12,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: widget.coordinator.dismissCurrent,
                      child: Ink(
                        width: 250,
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              colorScheme.surface.withValues(alpha: 0.98),
                              colorScheme.primary.withValues(alpha: 0.08),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: colorScheme.primary.withValues(alpha: 0.24),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.shadow.withValues(alpha: 0.10),
                              blurRadius: 18,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Text(
                            item.text,
                            textAlign: TextAlign.right,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
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
        fontSize: 18,
        fontWeight: FontWeight.w700,
        height: 1.75,
        color: colorScheme.onSurface,
      ),
    ),
  );
}

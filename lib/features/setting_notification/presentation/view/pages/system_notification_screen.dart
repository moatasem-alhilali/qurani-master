import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:quran_app/core/components/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/core/extensions/request_state_extension.dart';
import 'package:quran_app/core/notification/bloc/notification_bloc.dart';
import 'package:quran_app/core/theme/theme_data.dart';
import 'package:quran_app/features/setting_notification/presentation/view/widgets/system_active_notification_item_widget.dart';
import 'package:quran_app/features/setting_notification/presentation/view/widgets/system_notification_item_widget.dart';

class SystemNotificationScreen extends StatefulWidget {
  const SystemNotificationScreen({super.key});

  @override
  State<SystemNotificationScreen> createState() =>
      _SystemNotificationScreenState();
}

class _SystemNotificationScreenState extends State<SystemNotificationScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late List<AnimationController> _itemControllers;
  late List<Animation<double>> _itemAnimations;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Create individual controllers for each section
    _itemControllers = List.generate(
      4, // Number of sections
      (index) => AnimationController(
        duration: Duration(milliseconds: 400 + (index * 100)),
        vsync: this,
      ),
    );

    _itemAnimations = _itemControllers
        .map(
          (controller) => Tween<double>(
            begin: 0,
            end: 1,
          ).animate(
            CurvedAnimation(
              parent: controller,
              curve: Curves.easeOutCubic,
            ),
          ),
        )
        .toList();
  }

  void _startAnimations() {
    _fadeController.forward();

    // Stagger the item animations
    for (var i = 0; i < _itemControllers.length; i++) {
      Future.delayed(Duration(milliseconds: 100 * i), () {
        if (mounted) {
          _itemControllers[i].forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    for (final controller in _itemControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      title: 'اشعارات النظام',
      // isScroll: false,
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          return state.pendingNotificationsState
              .handle<PendingNotificationRequest>(
            list: state.pendingNotifications,
            context: context,
            onSuccess: () {
              final pendingNotifications = state.pendingNotifications;

              return FadeTransition(
                opacity: _fadeController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        'اشعارات النظام المجدولة',
                        style: titleMedium(context),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: pendingNotifications.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: 1),
                          duration: Duration(
                            milliseconds: 200 + (index * 100),
                          ),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, child) {
                            return Opacity(
                              opacity: value,
                              child: SystemNotificationItemWidget(
                                pendingNotification:
                                    pendingNotifications[index],
                              ),
                            );
                          },
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        'اشعارات النظام المفعلة',
                        style: titleMedium(context),
                      ),
                    ),
                    ListView.builder(
                      itemCount: state.activeNotifications.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: 1),
                          duration: Duration(
                            milliseconds: 200 + (index * 100),
                          ),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, child) {
                            return Opacity(
                              opacity: value,
                              child: SystemActiveNotificationItemWidget(
                                activeNotification:
                                    state.activeNotifications[index],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/notification/notification_service.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/features/young_muslim/data/data_sources/young_muslim_asset_data_source.dart';
import 'package:quran_app/features/young_muslim/data/data_sources/young_muslim_local_data_source.dart';
import 'package:quran_app/features/young_muslim/data/repositories/young_muslim_repository_impl.dart';
import 'package:quran_app/features/young_muslim/data/services/young_muslim_reminder_service.dart';
import 'package:quran_app/features/young_muslim/domain/repositories/young_muslim_repository.dart';
import 'package:quran_app/features/young_muslim/presentation/bloc/young_muslim_bloc.dart';
import 'package:quran_app/features/young_muslim/presentation/view/pages/young_muslim_home_screen.dart';

class YoungMuslimProvider extends StatefulWidget {
  const YoungMuslimProvider({super.key});

  @override
  State<YoungMuslimProvider> createState() => _YoungMuslimProviderState();
}

class _YoungMuslimProviderState extends State<YoungMuslimProvider> {
  late final YoungMuslimRepository _repository;
  late final YoungMuslimBloc _bloc;

  @override
  void initState() {
    super.initState();
    final localDataSource = YoungMuslimLocalDataSource();
    _repository = YoungMuslimRepositoryImpl(
      assetDataSource: YoungMuslimAssetDataSource(),
      localDataSource: localDataSource,
      reminderService: YoungMuslimReminderService(
        notificationService: sl<NotificationService>(),
        localDataSource: localDataSource,
      ),
    );
    _bloc = YoungMuslimBloc(repository: _repository)
      ..add(const YoungMuslimStarted());
  }

  @override
  void dispose() {
    unawaited(_bloc.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoungMuslimRouteScope(
      repository: _repository,
      bloc: _bloc,
      child: const YoungMuslimHomeScreen(),
    );
  }
}

class YoungMuslimRouteScope extends StatelessWidget {
  const YoungMuslimRouteScope({
    required this.repository,
    required this.bloc,
    required this.child,
    super.key,
  });

  final YoungMuslimRepository repository;
  final YoungMuslimBloc bloc;
  final Widget child;

  static Widget inherit({
    required BuildContext context,
    required Widget child,
  }) {
    return YoungMuslimRouteScope(
      repository: context.read<YoungMuslimRepository>(),
      bloc: context.read<YoungMuslimBloc>(),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<YoungMuslimRepository>.value(value: repository),
      ],
      child: BlocProvider<YoungMuslimBloc>.value(
        value: bloc,
        child: child,
      ),
    );
  }
}

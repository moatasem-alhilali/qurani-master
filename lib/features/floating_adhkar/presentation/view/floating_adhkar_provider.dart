import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/features/floating_adhkar/presentation/bloc/floating_adhkar_bloc.dart';
import 'package:quran_app/features/floating_adhkar/presentation/view/pages/floating_adhkar_screen.dart';

class FloatingAdhkarProvider extends StatelessWidget {
  const FloatingAdhkarProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FloatingAdhkarBloc>(
      create: (_) =>
          sl<FloatingAdhkarBloc>()..add(const FloatingAdhkarLoadEvent()),
      child: const FloatingAdhkarScreen(),
    );
  }
}

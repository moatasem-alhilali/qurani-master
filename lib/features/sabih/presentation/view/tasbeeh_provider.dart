import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/features/sabih/data/database/database_sabih_service.dart';
import 'package:quran_app/features/sabih/data/model/subih_seed_model.dart';
import 'package:quran_app/features/sabih/data/remote/sabih_repository_imp.dart';
import 'package:quran_app/features/sabih/presentation/bloc/sabih_bloc.dart';
import 'package:quran_app/features/sabih/presentation/view/pages/tasbeeh_screen.dart';

class TasbeehProvider extends StatefulWidget {
  const TasbeehProvider({super.key});

  @override
  State<TasbeehProvider> createState() => _TasbeehProviderState();
}

class _TasbeehProviderState extends State<TasbeehProvider> {
  late final SabihRepository _repository;
  late final SabihBloc _bloc;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _repository = SabihRepositoryImpl(
      sabihService: DatabaseSabihService(),
    );
    _bloc = SabihBloc(repository: _repository);

    // Seed default dhikr items if needed
    _seedData();
  }

  Future<void> _seedData() async {
    await SubihSeeder.seedIfEmpty();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: TasbeehScreen(
        isLoading: _isLoading,
      ),
    );
  }
}

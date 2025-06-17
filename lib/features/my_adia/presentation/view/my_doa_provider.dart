import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/features/my_adia/presentation/view/page/my_doa_screen.dart';
import 'package:quran_app/features/sabih/data/database/database_sabih_service.dart';
import 'package:quran_app/features/sabih/data/remote/sabih_repository_imp.dart';
import 'package:quran_app/features/sabih/presentation/bloc/sabih_bloc.dart';

class MuDoaProvider extends StatefulWidget {
  const MuDoaProvider({super.key});

  @override
  State<MuDoaProvider> createState() => _MuDoaProviderState();
}

class _MuDoaProviderState extends State<MuDoaProvider> {
  late final SabihRepository _repository;
  late final SabihBloc _bloc;

  @override
  void initState() {
    super.initState();
    _repository = SabihRepositoryImpl(
      sabihService: DatabaseSabihService(),
    );
    _bloc = SabihBloc(repository: _repository);
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
      child: const MuDoaScreen(),
    );
  }
}

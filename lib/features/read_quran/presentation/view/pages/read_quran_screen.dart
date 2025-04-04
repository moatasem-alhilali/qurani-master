import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/bloc/theme/theme_bloc.dart';
import 'package:quran_app/core/local/cash.dart';
import 'package:quran_app/features/read_quran/presentation/view/widgets/dialog/option_quran_dialog.dart';
import 'package:quran_app/features/read_quran/presentation/view/widgets/quran_body_widget.dart';

class ReadQuranScreen extends StatelessWidget {
  const ReadQuranScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            CashConfig.setLastRead();
            return true;
          },
          child: Scaffold(
            backgroundColor: context.currentThemeData.colorScheme.background,
            body: SafeArea(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _showQuickOptions(context),
                child: const QuranBodyWidget(),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showQuickOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const OptionQuranDialog(),
    );
  }
}

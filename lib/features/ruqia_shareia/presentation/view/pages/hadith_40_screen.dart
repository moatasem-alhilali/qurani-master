import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/components/base_home_widget.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/components/copy_icon_widget.dart';
import 'package:quran_app/core/components/icon_share_widget.dart';
import 'package:quran_app/core/components/readmore.dart';
import 'package:quran_app/core/components/shimmer_widget.dart';
import 'package:quran_app/core/extensions/request_state_extension.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/features/hadith_40/data/models/hadith_40_model.dart';
import 'package:quran_app/features/hadith_40/presentation/bloc/hadith_40_bloc.dart';
import 'package:quran_app/features/ruqia_shareia/data/models/ruqia_shareia_model.dart';
import 'package:quran_app/features/ruqia_shareia/presentation/bloc/ruqia_shareia_bloc.dart';

class RuqiaShareiaScreen extends StatelessWidget {
  const RuqiaShareiaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RuqiaShareiaBloc()..add(LoadRuqiaShareiaEvent()),
      child: BaseHomeWidget(
        title: 'أسماء الله الحسنى',
        body: BlocBuilder<RuqiaShareiaBloc, RuqiaShareiaState>(
          builder: (context, state) {
            return state.state.handle<RuqiaShareiaModel>(
              onSuccess: () {
                final data = state.data ?? [];
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];
                    return BaseAnimate(
                      index: 0,
                      child: CardWidget(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              item.category,
                              style: titleMedium(context),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            SelectableText(
                              item.zekr,
                              style: titleSmall(context).copyWith(
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "المرجع : ${item.reference == "" ? "القرأن الكريم" : item.reference}",
                              style: titleSmall(context).copyWith(
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Divider(),
                            Row(
                              children: [
                                IconShareWidget(
                                  text: item.zekr,
                                  subject: 'الرقية الشرعية',
                                ),
                                CopyIconWidget(
                                  text: item.zekr,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              onError: const Center(
                child: Text('error'),
              ),
              onLoading: const Center(
                child: CircularProgressIndicator(),
              ),
              list: state.data,
            );
          },
        ),
      ),
    );
  }
}

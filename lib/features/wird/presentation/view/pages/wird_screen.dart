import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/components/app_scaffold_widget.dart';
import 'package:quran_app/core/components/doa_item.dart';
import 'package:quran_app/core/components/shimmer_widget.dart';
import 'package:quran_app/core/extensions/request_state/request_state_sliver_extension.dart';
import 'package:quran_app/core/extensions/request_state_extension.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/core/services/copy_service.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/features/wird/data/models/wird_model.dart';
import 'package:quran_app/features/wird/presentation/bloc/wird_bloc.dart';

class WirdScreen extends StatelessWidget {
  const WirdScreen({required this.isMorning, super.key});
  final bool isMorning;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WirdBloc()..add(LoadWirdEvent()),
      child: AppScaffoldWidget(
        title: isMorning ? 'الورد الصباحي' : 'الورد المساءي',
        slivers: [BlocBuilder<WirdBloc, WirdState>(
          builder: (context, state) {
            return state.state.whenSliver<WirdModel>(
              onSuccess: () {
                final data = state.data ?? [];
                return SliverList.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];

                    return BaseAnimate(
                      index: 0,
                      child: Column(
                        children: [
                          DoaItem(
                            childPageNumber: Text(
                              '${data.length - 1}/$index',
                              style: titleSmall(context).copyWith(
                                color: context.primaryScheme,
                              ),
                            ),
                            fontFamily: 'ios-1',
                            color: context.primaryScheme,
                            content: item.text,
                            text: item.text,
                            number: 'التكرار :  ${item.counter} ',
                            onLongPress: () async {
                              await CopyService.copyToClipboard(
                                item.text,
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              context: context,
              sliverList: state.data,
              // list: state.data,
            );
            },
          ),
        ],
      ),
    );
  }
}

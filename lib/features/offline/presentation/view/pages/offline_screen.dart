import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/components/shimmer_widget.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/offline/data/remote/offline_repository_imp.dart';
import 'package:quran_app/features/offline/presentation/bloc/offline_bloc.dart';
import 'package:quran_app/features/offline/presentation/view/pages/offline_detail.dart';

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OfflineBloc(
        repositoryImpl: sl.get<OfflineRepositoryImpl>(),
      )..add(GetOfflineEvent()),
      child: BlocBuilder<OfflineBloc, OfflineState>(
        builder: (context, state) {
          return BlocConsumer<OfflineBloc, OfflineState>(
            listener: (context, state) {},
            builder: (context, state) {
              switch (state.getState) {
                case RequestState.initial:
                  return const Center(child: CircularProgressIndicator());
                case RequestState.loading:
                  return const Center(child: CircularProgressIndicator());
                case RequestState.error:
                  return const SizedBox();
                case RequestState.success:
                  return state.data.isEmpty
                      ? SizedBox(
                          height: context.getHight(30),
                          child: Center(
                            child: Text(
                              'لا يوجد تنزيلات بعد',
                              style: titleMedium(context),
                            ),
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              child: Text(
                                'التنزيلات',
                                style: titleMedium(context)
                                    .copyWith(color: context.primaryScheme),
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: context.getHight(20),
                              child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: types.length,
                                itemBuilder: (context, index) {
                                  return BaseAnimate(
                                    index: index,
                                    child: _Item(types[index], state.data),
                                  );
                                },
                              ),
                            ),
                            Text(
                              'الكل',
                              style: titleMedium(context),
                            ),
                            const Expanded(child: BuildItemOffline()),
                          ],
                        );
              }
            },
          );
        },
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item(this.type, this.data);
  final dynamic type;
  final List data;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              context.push(OfflineDetail(data: type));
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(
                    child: Text(
                      type['title'] as String,
                      style: titleMedium(context)
                          .copyWith(color: context.primaryScheme),
                    ),
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 7,
                        child: FittedBox(
                          child: Text(
                            _onSearchTextChanged(data, type['type'])
                                .length
                                .toString(),
                          ),
                        ),
                      ),
                      Icon(
                        Icons.folder_open_rounded,
                        color: context.primaryScheme,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<dynamic> _onSearchTextChanged(List data, value) {
    final res = data
        .where(
          (data) =>
              data['type'].toString().toLowerCase().contains(value.toString()),
        )
        .toList();
    return res;
  }
}

List<Map<String, dynamic>> types = [
  {
    'title': 'صوت',
    'type': 'mp3',
  },
  {
    'title': 'الفيديو',
    'type': 'mp4',
  },
];

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/components/base_home.dart';
import 'package:quran_app/core/components/shimmer_base.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/core/services/clip_board_services.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/another_screen/data/models/hisn_almuslim_model.dart';
import 'package:quran_app/features/another_screen/presentation/bloc/hisn_muslim/hisn_muslim_bloc.dart';
import 'package:quran_app/features/another_screen/presentation/bloc/hisn_muslim/hisn_muslim_event.dart';
import 'package:quran_app/features/another_screen/presentation/bloc/hisn_muslim/hisn_muslim_state.dart';

class HisnMuslimScreen extends StatefulWidget {
  const HisnMuslimScreen({super.key});

  @override
  State<HisnMuslimScreen> createState() => _HisnMuslimScreenState();
}

class _HisnMuslimScreenState extends State<HisnMuslimScreen> {
  @override
  void initState() {
    context.read<HisnMuslimBloc>().add(LoadHisnMuslimEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseHome(
      title: "حصن المسلم",
      body: BlocBuilder<HisnMuslimBloc, HisnMuslimState>(
        builder: (context, state) {
          if (state is HisnMuslimLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is HisnMuslimLoaded) {
            final data = state.hisnMuslim;

            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                return BaseAnimateFlipList(
                  index: index,
                  child: InkWell(
                    onTap: () => _showDetailBottomSheet(context, item),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: index % 2 == 0
                            ? context.primaryScheme
                            : Colors.transparent,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child:
                                  Text(item.title, style: titleSmall(context))),
                          CircleAvatar(
                            backgroundColor: index % 2 == 0
                                ? context.primaryScheme
                                : context.primarySecondary,
                            radius: 18,
                            child: Text("${index + 1}"),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          if (state is HisnMuslimError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showDetailBottomSheet(BuildContext context, HisnMuslimModel item) {
    context.showBottomSheet(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(item.title, style: titleMedium(context))),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () {
                        // share logic
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () async {
                        await ClipBoardServices.copyText(
                          text: '${item.title}\n\n${item.text.join('\n\n')}',
                          message: "تم النسخ بنجاح",
                        );
                      },
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 12),

            // Text
            ...item.text.map((t) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(t, style: titleSmall(context)),
                )),

            const SizedBox(height: 12),

            if (item.footnote.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("الحواشي:", style: titleSmall(context)),
                  const SizedBox(height: 8),
                  ...item.footnote.map(
                    (f) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text("• $f",
                          style: const TextStyle(color: Colors.grey)),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

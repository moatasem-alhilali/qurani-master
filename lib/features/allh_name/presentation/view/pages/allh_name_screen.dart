import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/base_home.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/components/copy_icon_widget.dart';
import 'package:quran_app/core/components/icon_share_widget.dart';
import 'package:quran_app/core/components/shimmer_widget.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/features/allh_name/presentation/bloc/allah_names_bloc.dart';
import 'package:quran_app/features/allh_name/presentation/bloc/allah_names_event.dart';
import 'package:quran_app/features/allh_name/presentation/bloc/allah_names_state.dart';

class AllhNameScreen extends StatefulWidget {
  const AllhNameScreen({super.key});

  @override
  State<AllhNameScreen> createState() => _AllhNameScreenState();
}

class _AllhNameScreenState extends State<AllhNameScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AllahNamesBloc>().add(LoadAllahNamesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BaseHome(
      title: 'أسماء الله الحسنى',
      body: BlocBuilder<AllahNamesBloc, AllahNamesState>(
        builder: (context, state) {
          if (state is AllahNamesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AllahNamesError) {
            return Center(child: Text(state.message));
          }

          if (state is AllahNamesLoaded) {
            final data = state.data;

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                return BaseAnimate(
                  index: index,
                  child: CardWidget(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: titleMedium(context).copyWith(
                            fontSize: 14.sp,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          item.text,
                          style: titleSmall(context).copyWith(
                            fontSize: 10.sp,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Divider(),
                        Row(
                          children: [
                            IconShareWidget(
                              text: '${item.name} : ${item.text}',
                              subject: 'أسماء الله الحسنى',
                            ),
                            CopyIconWidget(
                              text: '${item.name} : ${item.text}',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox(); // fallback
        },
      ),
    );
  }
}

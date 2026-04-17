import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/sabih/presentation/bloc/sabih_bloc.dart';
import 'package:quran_app/features/sabih/presentation/view/widgets/add_dhikr_dialog.dart';
import 'package:quran_app/features/sabih/presentation/view/widgets/tasbeeh/tasbeeh_analytics_header.dart';
import 'package:quran_app/features/sabih/presentation/view/widgets/tasbeeh/tasbeeh_carousel.dart';

class TasbeehScreen extends StatefulWidget {
  const TasbeehScreen({super.key});

  @override
  State<TasbeehScreen> createState() => _TasbeehScreenState();
}

class _TasbeehScreenState extends State<TasbeehScreen> {
  @override
  void initState() {
    super.initState();
    // LoadAllSubihEvent natively loads today's counts automatically!
    context.read<SabihBloc>().add(LoadAllSubihEvent());
  }

  void _showAddDhikrDialog() {
    context.showBottomSheetUIHeader(
      child: BlocProvider.value(
        value: context.read<SabihBloc>(),
        child: const AddDhikrDialog(),
      ),
      title: 'إضافة ذكر مخصص',
      subtitle: 'ذكر مخصص هو ذكر يمكنك إضافته لتصبح ذكرك الأول',
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      title: 'المسبحة (الذكر)',
      body: Column(
        children: [
          const TasbeehAnalyticsHeader(),
          const SizedBox(height: 16),
          BlocConsumer<SabihBloc, SabihState>(
            listenWhen: (previous, current) =>
                previous.actionState != current.actionState,
            listener: (context, state) {
              if (state.actionState == RequestState.error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage ?? 'حدث خطأ'),
                  ),
                );
              }
            },
            buildWhen: (previous, current) =>
                previous.loadState != current.loadState ||
                previous.subihList != current.subihList ||
                previous.countsMap != current.countsMap,
            builder: (context, state) {
              if (state.loadState == LoadState.initial) {
                return const Center(child: Text('ابدأ رحلة ذكرك'));
              }

              if (state.loadState == LoadState.loading &&
                  state.subihList.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.loadState == LoadState.error) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.errorMessage ?? 'حدث خطأ'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<SabihBloc>().add(LoadAllSubihEvent());
                        },
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                );
              }

              if (state.subihList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('لم يتم العثور على عناصر ذكر'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _showAddDhikrDialog,
                        child: const Text('أضف ذكرك الأول'),
                      ),
                    ],
                  ),
                );
              }

              return TasbeehCarousel(state: state);
            },
          ),
        ],
      ),
      floatingActionButton: BlocBuilder<SabihBloc, SabihState>(
        builder: (context, state) {
          return FloatingActionButton(
            onPressed: _showAddDhikrDialog,
            tooltip: 'إضافة ذكر مخصص',
            child: const Icon(Icons.add),
          );
        },
      ),
    );
  }
}

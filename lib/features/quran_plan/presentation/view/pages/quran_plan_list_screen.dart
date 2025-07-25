import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/components/app_scaffold_widget.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/extensions/request_state/request_state_sliver_extension.dart';
import 'package:quran_app/core/extensions/text_styles_extension.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/quran_plan/data/model/quran_plan_model.dart';
import 'package:quran_app/features/quran_plan/presentation/bloc/quran_plan_bloc.dart';
import 'package:quran_app/features/quran_plan/presentation/view/pages/quran_plan_add_screen.dart';
import 'package:quran_app/features/quran_plan/presentation/view/pages/quran_plan_session_screen.dart';

class QuranPlanListScreen extends StatelessWidget {
  const QuranPlanListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<QuranPlanBloc>()..add(LoadAllPlansEvent()),
      child: BlocBuilder<QuranPlanBloc, QuranPlanState>(
        builder: (context, state) {
          return AppScaffoldWidget(
            title: 'خطط الختم',
            onRefresh: () async {
              context.read<QuranPlanBloc>().add(LoadAllPlansEvent());
            },
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const QuranPlanAddScreen()),
                );
              },
              child: const Icon(Icons.add),
            ),
            slivers: [
              BlocBuilder<QuranPlanBloc, QuranPlanState>(
                builder: (context, state) {
                  return state.requestState.whenSliver<QuranPlan>(
                    onSuccess: () {
                      return SliverList.separated(
                        itemCount: state.plans.length,
                        separatorBuilder: (ctx, i) =>
                            const SizedBox(height: 16),
                        itemBuilder: (ctx, i) {
                          final plan = state.plans[i];
                          return CardWidget(
                            margin: const EdgeInsets.only(bottom: 24),
                            padding: const EdgeInsets.all(18),
                            child: ListTile(
                              title: Text(
                                plan.title,
                                style: context.bodyMedium,
                              ),
                              subtitle: Text(
                                'من الجزء ${plan.startJuz} إلى ${plan.endJuz} • أيام: ${plan.totalDays}',
                                style: context.bodyMedium,
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  context
                                      .read<QuranPlanBloc>()
                                      .add(DeletePlanEvent(plan.id!));
                                },
                              ),
                              onTap: () {
                                context
                                    .push(QuranPlanSessionScreen(plan: plan));
                              },
                            ),
                          );
                        },
                      );
                    },
                    context: context,
                    sliverList: state.plans,
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

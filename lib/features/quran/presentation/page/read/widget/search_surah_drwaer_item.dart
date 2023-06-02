import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/jsons/assets_text.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/features/quran/presentation/cubit/quran_cubit_cubit.dart';

class SearchSurahDrawerItem extends StatelessWidget {
  const SearchSurahDrawerItem({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuranCubit, QuranCubitState>(
      builder: (context, state) {
        if (state is SearchSurahNoDataState) {
          return Container();
        }
        if (state is SearchSurahSuccessesState) {
          return Expanded(
            child: ListView.builder(
              itemCount: state.data.length,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (_, index) {
                var data = state.data[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      if (QuranCubit.get(context).isSurahReadAndListen) {
                        QuranCubit.get(context).currentAyahSelected = null;
                        QuranCubit.get(context).indexSurahRead =
                            int.parse(data['surah']);
                        QuranCubit.get(context).initPlayerPlayAyah(
                          surahNumber: QuranCubit.get(context).indexSurahRead,
                        );
                        Scaffold.of(context).closeDrawer();
                        QuranCubit.get(context).mySetState();
                      } else {
                        QuranCubit.get(context).currentAyahSelected = null;
                        QuranCubit.get(context).indexSurahRead =
                            int.parse(data['surah']);
                        QuranCubit.get(context).initPlayerPlayAyah(
                          surahNumber: QuranCubit.get(context).indexSurahRead,
                        );
                        QuranCubit.get(context).pageController!.jumpToPage(0);
                        Scaffold.of(context).closeDrawer();
                        QuranCubit.get(context).mySetState();
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: index % 2 == 0
                            ? null
                            : Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            data['name'],
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(color: Colors.white),
                          ),
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: ColorsManager.customPrimary,
                            child: Text(
                              "${int.parse(data['surah'])}",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
        return Container();
      },
    );
  }
}

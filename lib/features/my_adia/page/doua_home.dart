import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quran_app/core/components/base_home.dart';
import 'package:quran_app/core/components/custom_app_bar.dart';
import 'package:quran_app/features/my_adia/core/adia_cubit_cubit.dart';
import 'package:quran_app/features/my_adia/core/db/db_helper_note.dart';
import 'package:quran_app/features/my_adia/page/AddDua.dart';
import 'package:quran_app/core/components/doa_item.dart';
import 'package:quran_app/features/my_adia/widget/button.dart';
import 'package:quran_app/core/util/toast_manager.dart';

import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/shared/resources/assets_manager.dart';

// import '../core/adia_cubit_cubit.dart';
// import '../widget/DoaItem.dart';
import 'editDoa.dart';

Future<void> setCashData(
    {required String key, required dynamic value, String? message}) async {
  await CashHelper.setData(key: key, value: value).then((value) {
    ToastServes.showToast(message: message);
  });
}

Future<void> setCopyBoard({required String value, String? message}) async {
  Clipboard.setData(
    ClipboardData(
      text: value,
    ),
  ).then((value) {
    ToastServes.showToast(message: message);
  });
}

class DouaHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdiaCubitCubit, AdiaCubitState>(
      listener: (context, state) {
        if (state is DeleteDoaState) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return BaseHome(
          customAppBar: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "أدعيتي",
                  style: titleMedium(context),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        navigateTo(AddDua(), context);
                      },
                      icon: const Icon(Icons.add_home_rounded),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios_new),
                    ),
                  ],
                ),
              ],
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (AdiaCubitCubit.get(context).doaList.isEmpty)
                const NoDoau()
              else
                ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: AdiaCubitCubit.get(context).doaList.length,
                  shrinkWrap: true,
                  itemBuilder: (_, index) {
                    var data = AdiaCubitCubit.get(context).doaList[index];

                    return InkWell(
                      onTap: () {
                        showCustomBottomSheets(context, data);
                      },
                      child: DoaItem(
                        childPageNumber: Container(),
                        color: defaultColor,
                        content: data.content,
                        number: '',
                        text: data.title,
                        onTap: () {
                          Clipboard.setData(
                            ClipboardData(
                                text: AdiaCubitCubit.get(context)
                                    .doaList[index]
                                    .content),
                          ).then(
                            (value) {
                              ToastServes.showToast(message: 'تم النسخ بنجاح');
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> showCustomBottomSheets(BuildContext context, DoaModel doaList) {
    return showModalBottomSheet<void>(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 150,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MyButtonCustom(
                    onTap: () {
                      AdiaCubitCubit.get(context).deleteDoa(doaModel: doaList);
                    },
                    lable: 'حذف ',
                    color: Colors.red,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MyButtonCustom(
                    onTap: () {
                      navigateTo(
                          EditDua(
                            content: doaList.content,
                            title: doaList.title,
                            id: doaList.id,
                          ),
                          context);
                    },
                    lable: 'تعديل ',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class NoDoau extends StatelessWidget {
  const NoDoau({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              'لايوجد لديك ادعيه حاليا',
              style: titleLarge(context),
            ),
          ),
        ],
      ),
    );
  }
}

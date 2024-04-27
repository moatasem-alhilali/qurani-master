import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/components/base_home.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/my_adia/core/adia_cubit_cubit.dart';
import 'package:quran_app/features/my_adia/doa_model.dart';
import 'package:quran_app/features/my_adia/page/AddDua.dart';
import 'package:quran_app/core/components/doa_item.dart';
import 'package:quran_app/features/my_adia/widget/button.dart';
import 'package:quran_app/core/util/toast_manager.dart';

import 'package:quran_app/core/shared/export/export-shared.dart';

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
  const DouaHome({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdiaCubit()..getDoa(),
      child: BlocConsumer<AdiaCubit, AdiaCubitState>(
        listener: (context, state) {
          if (state is DeleteDoaState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return BaseHome(
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                context.showBottomSheet(child: AddDua());
              },
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (AdiaCubit.get(context).doaList.isEmpty) const NoDoau(),
                ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: AdiaCubit.get(context).doaList.length,
                  shrinkWrap: true,
                  itemBuilder: (_, index) {
                    var data = AdiaCubit.get(context).doaList[index];

                    return DoaItem(
                      childPageNumber: Container(),
                      color: defaultColor,
                      content: data.content,
                      number: '',
                      text: data.title,
                      onTap: () {
                        context.showBottomSheet(
                          child: SizedBox(
                            height: 150,
                            child: Center(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: MyButtonCustom(
                                      onTap: () {
                                        AdiaCubit.get(context)
                                            .deleteDoa(doaModel: data);
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
                                            content: data.content,
                                            title: data.title,
                                            id: data.id,
                                          ),
                                          context,
                                        );
                                      },
                                      lable: 'تعديل ',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      onLongPress: () {
                        Clipboard.setData(
                          ClipboardData(
                              text: AdiaCubit.get(context)
                                  .doaList[index]
                                  .content??""),
                        ).then(
                          (value) {
                            ToastServes.showToast(message: 'تم النسخ بنجاح');
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void showCustomBottomSheets(BuildContext context, DoaModel doaList) {}
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

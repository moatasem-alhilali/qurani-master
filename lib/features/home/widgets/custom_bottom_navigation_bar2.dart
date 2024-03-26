import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/bloc/base_bloc.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/util/my_extensions.dart';

int currentPage = 0;

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  var currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Color(0xff252525),
      ),
      height: context.getHight(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _IconItem(
            onTap: () {
              currentPage = 0;
              BlocProvider.of<BaseBloc>(context).add(SetStateBaseBlocEvent());
            },
            index: 0,
            icon: listOfIcons[0],
            title: titles[0],
          ),
          _IconItem(
            onTap: () {
              currentPage = 1;
              BlocProvider.of<BaseBloc>(context).add(SetStateBaseBlocEvent());
            },
            index: 1,
            icon: listOfIcons[1],
            title: titles[1],
          ),
          // _IconItem(
          //   onTap: () {
          //     currentPage = 2;
          //     BlocProvider.of<BaseBloc>(context).add(SetStateBaseBlocEvent());
          //   },
          //   index: 2,
          //   icon: listOfIcons[2],
          //   title: titles[2],
          // ),
          // _IconItem(
          //   onTap: () {
          //     currentPage = 3;
          //     // context.read<HomeBloc>().add(GetProfileEvent());
          //     context.read<BaseBloc>().add(SetStateBaseBlocEvent());
          //   },
          //   index: 3,
          //   icon: listOfIcons[3],
          //   title: titles[3],
          // ),

          _IconItem(
            onTap: () {
              currentPage = 2;
              // context.read<HomeBloc>().add(GetProfileEvent());
              context.read<BaseBloc>().add(SetStateBaseBlocEvent());
            },
            index: 3,
            icon: listOfIcons[2],
            title: titles[2],
          ),
        ],
      ),
    );
  }
}

class _IconItem extends StatelessWidget {
  const _IconItem({
    required this.index,
    required this.icon,
    required this.title,
    required this.onTap,
  });
  final int index;
  final IconData icon;
  final String title;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocBuilder<BaseBloc, BaseState>(
      builder: (context, state) {
        return InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: index == currentPage ? FxColors.secondary : null,
                ),
                child: Column(
                  children: [
                    Icon(
                      icon,
                      size: size.width * .076,
                      color: index == currentPage
                          ? FxColors.primary
                          : FxColors.primary.withOpacity(0.8),
                    ),
                    Text(
                      title,
                      style: TextStyle(
                        color: index == currentPage
                            ? FxColors.primary
                            : FxColors.primary.withOpacity(0.8),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 1500),
                curve: Curves.fastLinearToSlowEaseIn,
                // margin: EdgeInsets.only(
                //   right: size.width * .0422,
                //   left: size.width * .0422,
                //   top: 4,
                // ),
                width: size.width * .10,
                height: index == currentPage ? size.width * .014 : 0,
                decoration: BoxDecoration(
                  color: FxColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              // if (index != currentPage) SizedBox(height: size.width * .03),
            ],
          ),
        );
      },
    );
  }
}

List<IconData> listOfIcons = [
  CupertinoIcons.home,
  CupertinoIcons.collections,
  // CupertinoIcons.collections_solid,
  CupertinoIcons.cloud_download,
];
List<String> titles = [
  'الرئيسية',
  'الاقسام',
  // 'المزيد',
  'التنزيلات',
];

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/bloc/base/base_bloc.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';

int currentPage = 0;

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(10),
      // decoration: BoxDecoration(
      //   color: context.secondary,
      // ),
      // height: context.getHight(12),
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
          _IconItem(
            onTap: () {
              currentPage = 2;
              context.read<BaseBloc>().add(SetStateBaseBlocEvent());
            },
            index: 2,
            icon: listOfIcons[2],
            title: titles[2],
          ),
          _IconItem(
            onTap: () {
              currentPage = 3;
              context.read<BaseBloc>().add(SetStateBaseBlocEvent());
            },
            index: 3,
            icon: listOfIcons[3],
            title: titles[3],
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
    final size = MediaQuery.of(context).size;

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
                  color: index == currentPage ? context.secondary : null,
                ),
                child: Column(
                  children: [
                    Icon(
                      icon,
                      size: size.width * .076,
                      color: index == currentPage
                          ? context.primaryScheme
                          : context.gray1,
                    ),
                    Text(
                      title,
                      style: TextStyle(
                        color: index == currentPage
                            ? context.primaryScheme
                            : context.gray1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 1500),
                curve: Curves.fastLinearToSlowEaseIn,
                width: size.width * .10,
                height: index == currentPage ? size.width * .014 : 0,
                decoration: BoxDecoration(
                  color: context.primaryScheme,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
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
  CupertinoIcons.cloud_download,
  CupertinoIcons.settings_solid,
];
List<String> titles = [
  'الرئيسية',
  'الاقسام',
  'التنزيلات',
  'الإعدادات',
];

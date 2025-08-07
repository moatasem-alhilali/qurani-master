import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/bloc/theme/theme_bloc.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/package/flutter_sliding_box.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran/read_quran_bloc.dart';
import 'package:quran_app/features/read_quran/presentation/view/widgets/backdrop_option_quran_widget.dart';
import 'package:quran_app/features/read_quran/presentation/view/widgets/horizontal/body_read_quran_horizontal_widget.dart';
import 'package:quran_app/features/read_quran/presentation/view/widgets/tafser/body_read_quran_tafser_widget.dart';
import 'package:quran_app/features/read_quran/presentation/view/widgets/vertical/body_read_quran_vertical_widget.dart';
import 'package:quran_app/features/search/presentation/bloc/search_bloc.dart';
import 'package:quran_app/features/search/presentation/view/widgets/sarch_ayah_list_widget.dart';

class ReadQuranScreen extends StatefulWidget {
  const ReadQuranScreen({super.key, this.page});
  final int? page;

  @override
  State<ReadQuranScreen> createState() => _ReadQuranScreenState();
}

class _ReadQuranScreenState extends State<ReadQuranScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.page != null) {
        context.read<ReadQuranBloc>().add(JumpToPageEvent(page: widget.page));
      } else {
        context.read<ReadQuranBloc>().add(JumpToPageEvent());
      }
      context.read<ReadQuranBloc>().add(ToggleBoxEvent());
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return BlocBuilder<ReadQuranBloc, ReadQuranState>(
          builder: (context, state) {
            final boxController = context.read<ReadQuranBloc>().boxController;
            final isTafser = state.isTafser;
            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle(
                statusBarColor: context.primaryColor,
                statusBarIconBrightness: Brightness.dark,
                statusBarBrightness: Brightness.dark,
              ),
              child: Scaffold(
                backgroundColor: !isTafser ? const Color(0xFFF1F2F4) : null,
                body: SlidingBox(
                  minHeight: 50,
                  onSearchBoxHide: () {
                    context.read<ReadQuranBloc>().add(
                          ToggleHighBoxEvent(),
                        );
                  },
                  onSearchBoxShow: () {
                    context.read<ReadQuranBloc>().add(
                          ToggleHighBoxEvent(
                            minusHeight: 0,
                          ),
                        );
                  },
                  maxHeight:
                      MediaQuery.of(context).size.height - state.minusHeight,
                  controller: boxController,
                  color: !isTafser
                      ? const Color(0xFFF1F2F4)
                      : context.scaffoldBackgroundColor,
                  backdrop: Backdrop(
                    fading: true,
                    color: !isTafser
                        ? const Color(0xFFF1F2F4)
                        : context.scaffoldBackgroundColor,

                    body: const BodyReadQuranHorizontalWidget(),
                    // body: isVertical
                    //     ? const BodyReadQuranVerticalWidget()
                    //     : const BodyReadQuranHorizontalWidget(),

                    appBar: BackdropAppBar(
                      searchBox: SearchBox(
                        controller:
                            context.read<SearchBloc>().textEditingController,
                        color: context.primaryColor,
                        inputDecoration: InputDecoration(
                          hintText: 'ابحث عن الايه',
                          hintStyle: const TextStyle(
                            color: Color(0xFFF1F2F4),
                          ),
                          filled: true,
                          fillColor:
                              context.primaryColor.withValues(alpha: 0.1),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: context.primaryColor,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: context.primaryColor,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: context.primaryColor,
                            ),
                          ),
                        ),
                        style: TextStyle(
                          color: context.onSurfaceColor,
                          fontSize: 18,
                        ),
                        body: const SearchAyahListWidget(),
                      ),
                    ),
                  ),
                  collapsedBody: Center(
                    child: Text(
                      'اسحب هنا للاعلي',
                      style: TextStyle(
                        color: context.primaryColor,
                      ),
                    ),
                  ),
                  draggableIconColor: context.primaryColor,
                  body: const BackdropOptionQuranWidget(),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

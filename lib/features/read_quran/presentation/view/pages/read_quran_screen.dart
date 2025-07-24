import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/bloc/theme/theme_bloc.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/core/package/flutter_sliding_box.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran/read_quran_bloc.dart';
import 'package:quran_app/features/read_quran/presentation/view/widgets/backdrop_option_quran_widget.dart';
import 'package:quran_app/features/read_quran/presentation/view/widgets/horizontal/body_read_quran_horizontal_widget.dart';
import 'package:quran_app/features/search/presentation/bloc/search_bloc.dart';
import 'package:quran_app/features/search/presentation/view/widgets/sarch_ayah_list_widget.dart';

class ReadQuranScreen extends StatefulWidget {
  const ReadQuranScreen({super.key});

  @override
  State<ReadQuranScreen> createState() => _ReadQuranScreenState();
}

class _ReadQuranScreenState extends State<ReadQuranScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReadQuranBloc>().add(JumpToPageEvent());
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
            return Scaffold(
              backgroundColor: const Color(0xFFF1F2F4),
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
                color: const Color(0xFFF1F2F4),
                backdrop: Backdrop(
                  fading: true,
                  color: const Color(0xFFF1F2F4),
                  appBar: BackdropAppBar(
                    searchBox: SearchBox(
                      controller:
                          context.read<SearchBloc>().textEditingController,
                      color: context.primaryScheme,
                      inputDecoration: InputDecoration(
                        hintText: 'ابحث عن الايه',
                        hintStyle: const TextStyle(
                          color: Color(0xFFF1F2F4),
                        ),
                        filled: true,
                        fillColor: context.primaryScheme.withValues(alpha: 0.1),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: context.primaryScheme,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: context.primaryScheme,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: context.primaryScheme,
                          ),
                        ),
                      ),
                      style: TextStyle(
                        color: context.colorScheme.onSurface,
                        fontSize: 18,
                      ),
                      body: const SearchAyahListWidget(),
                    ),
                  ),
                  body: const BodyReadQuranHorizontalWidget(),
                  // body: const BodyReadQuranVerticalWidget(),
                ),
                collapsedBody: Center(
                  child: Text(
                    'اسحب هنا للاعلي',
                    style: TextStyle(
                      color: context.primaryScheme,
                    ),
                  ),
                ),
                draggableIconColor: context.primaryScheme,
                body: const BackdropOptionQuranWidget(),
              ),
            );
          },
        );
      },
    );
  }
}

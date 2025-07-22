import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/bloc/theme/theme_bloc.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/core/package/flutter_sliding_box.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/old_read_quran/old_read_quran_bloc.dart';
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
      context.read<OldReadQuranBloc>().add(OldJumpToPageEvent());
      context.read<OldReadQuranBloc>().add(OldToggleBoxEvent());
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return BlocBuilder<OldReadQuranBloc, OldReadQuranState>(
          builder: (context, state) {
            final boxController =
                context.read<OldReadQuranBloc>().boxController;
            return Scaffold(
              backgroundColor: context.scaffoldBackgroundColor,
              body: SlidingBox(
                minHeight: 50,
                onSearchBoxHide: () {
                  context.read<OldReadQuranBloc>().add(
                        OldToggleHighBoxEvent(),
                      );
                },
                onSearchBoxShow: () {
                  context.read<OldReadQuranBloc>().add(
                        OldToggleHighBoxEvent(
                          minusHeight: 0,
                        ),
                      );
                },
                maxHeight:
                    MediaQuery.of(context).size.height - state.minusHeight,
                controller: boxController,
                color: context.scaffoldBackgroundColor,
                backdrop: Backdrop(
                  fading: true,
                  color: context.scaffoldBackgroundColor,
                  appBar: BackdropAppBar(
                    searchBox: SearchBox(
                      controller:
                          context.read<SearchBloc>().textEditingController,
                      color: context.primaryScheme,
                      inputDecoration: InputDecoration(
                        hintText: 'ابحث عن الايه',
                        hintStyle: TextStyle(
                          color: context.scaffoldBackgroundColor,
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
                        color: Theme.of(context).colorScheme.onSurface,
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

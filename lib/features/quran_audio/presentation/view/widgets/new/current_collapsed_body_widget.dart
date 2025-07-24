import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/core/package/flutter_sliding_box.dart';

class CurrentMusicCollapsedBodyWidget extends StatelessWidget {
  const CurrentMusicCollapsedBodyWidget({
    required this.boxController,
    super.key,
  });
  final BoxController boxController;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (boxController.isBoxClosed) boxController.openBox();
      },
      child: ColoredBox(
        color: context.primaryScheme,
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.all(10),
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(40)),
              ),
              child: const CircleAvatar(
                backgroundColor: Colors.white,
              ),
            ),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Title',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  Text(
                    'Artist, Album',
                    style: TextStyle(fontSize: 13, color: Colors.white),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 200,
              height: 40,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      CupertinoIcons.backward_end_alt_fill,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      CupertinoIcons.play_arrow_solid,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      CupertinoIcons.forward_end_alt_fill,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      CupertinoIcons.music_note_list,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

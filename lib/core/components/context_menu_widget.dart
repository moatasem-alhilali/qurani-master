import 'package:flutter/cupertino.dart';

class ContextMenuWidget extends StatelessWidget {
  const ContextMenuWidget({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return CupertinoContextMenu(
      actions: <Widget>[
        CupertinoContextMenuAction(
          onPressed: () {
            Navigator.pop(context);
          },
          isDefaultAction: true,
          trailingIcon: CupertinoIcons.doc_on_clipboard_fill,
          child: const Text('Copy'),
        ),
        CupertinoContextMenuAction(
          onPressed: () {
            Navigator.pop(context);
          },
          trailingIcon: CupertinoIcons.share,
          child: const Text('Share'),
        ),
        CupertinoContextMenuAction(
          onPressed: () {
            Navigator.pop(context);
          },
          trailingIcon: CupertinoIcons.heart,
          child: const Text('Favorite'),
        ),
        CupertinoContextMenuAction(
          onPressed: () {
            Navigator.pop(context);
          },
          isDestructiveAction: true,
          trailingIcon: CupertinoIcons.delete,
          child: const Text('Delete'),
        ),
      ],
      child: child,
    );
  }
}

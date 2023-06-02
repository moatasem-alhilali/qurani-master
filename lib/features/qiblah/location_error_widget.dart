import 'package:flutter/material.dart';

class LocationErrorWidget extends StatelessWidget {
  final String? error;
  final Function? callback;

  const LocationErrorWidget({Key? key, this.error, this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const errorColor = Color(0xffb00020);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(
            Icons.location_off,
            size: 150,
            color: errorColor,
          ),
          const SizedBox(height: 32),
          Text(
            error!,
            style:
                const TextStyle(color: errorColor, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            child: const Text("Retry"),
            onPressed: () {
              if (callback != null) callback!();
            },
          )
        ],
      ),
    );
  }
}

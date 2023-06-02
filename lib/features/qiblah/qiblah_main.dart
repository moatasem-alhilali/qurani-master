import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:quran_app/core/components/custom_app_bar.dart';

import 'qiblah_compass.dart';

class QiblahMain extends StatelessWidget {
  QiblahMain({super.key});
  final _deviceSupport = FlutterQiblah.androidDeviceSensorSupport();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              CustomAppBar(
                text: "القبلة",
                iconWidget: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              FutureBuilder(
                future: _deviceSupport,
                builder: (_, AsyncSnapshot<bool?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Error: ${snapshot.error.toString()}"),
                    );
                  }
                  if (snapshot.data!) {
                    return QiblahCompass();
                  } else {
                    return Center(
                      child: Text(
                        "Your device is not supported",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

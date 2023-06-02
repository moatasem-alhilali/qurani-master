import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NoInterNet extends StatelessWidget {
  const NoInterNet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Lottie.asset('assets/lottie/no-internet.json'),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'قم بالإتصال بالإنترنت لكي تتمكن من تنزيل القرأن الكريم والسماع اليه في حالة عدم وجود لديك انترنت ',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}

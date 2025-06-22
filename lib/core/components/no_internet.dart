import 'package:flutter/material.dart';

class NoInterNet extends StatelessWidget {
  const NoInterNet({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
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

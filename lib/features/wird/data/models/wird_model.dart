import 'package:equatable/equatable.dart';

class WirdModel extends Equatable {
  const WirdModel({
    required this.text,
    required this.counter,
  });

  factory WirdModel.fromJson(Map<String, dynamic> json) {
    return WirdModel(
      text: json['text'] as String,
      counter: json['counter'] as int,
    );
  }
  final String text;
  final int counter;

  @override
  List<Object?> get props => [text, counter];
}

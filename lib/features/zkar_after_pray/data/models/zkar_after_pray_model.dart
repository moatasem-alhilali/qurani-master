import 'package:equatable/equatable.dart';

class ZkarAfterPrayModel extends Equatable {
  const ZkarAfterPrayModel({
    required this.zekr,
    required this.repeat,
    required this.bless,
  });

  factory ZkarAfterPrayModel.fromJson(Map<String, dynamic> json) {
    return ZkarAfterPrayModel(
      zekr: json['zekr'] as String,
      repeat: json['repeat'] as int,
      bless: json['bless'] as String,
    );
  }
  final String zekr;
  final int repeat;
  final String bless;

  @override
  List<Object?> get props => [zekr, repeat, bless];
}

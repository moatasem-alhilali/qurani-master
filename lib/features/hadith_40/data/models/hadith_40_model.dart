import 'package:equatable/equatable.dart';

class Hadith40Model extends Equatable {
  const Hadith40Model({
    required this.hadith,
    required this.description,
  });

    factory Hadith40Model.fromJson(Map<String, dynamic> json) {
    return Hadith40Model(
      hadith: json['hadith'] as String,
      description: json['description'] as String,
    );
  }
  final String hadith;
  final String description;

  @override
  List<Object?> get props => [hadith, description];
}

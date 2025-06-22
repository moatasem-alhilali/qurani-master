import 'package:equatable/equatable.dart';

class RuqiaShareiaModel extends Equatable {
  const RuqiaShareiaModel({
    required this.category,
    required this.count,
    required this.description,
    required this.reference,
    required this.zekr,
  });

  factory RuqiaShareiaModel.fromJson(Map<String, dynamic> json) {
    return RuqiaShareiaModel(
      category: json['category'] as String,
      count: json['count'] as String,
      description: json['description'] as String,
      reference: json['reference'] as String,
      zekr: json['zekr'] as String,
    );
  }
  final String category;
  final String count;
  final String description;
  final String reference;
  final String zekr;

  @override
  List<Object?> get props => [category, count, description, reference, zekr];
}

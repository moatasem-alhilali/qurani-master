import 'package:equatable/equatable.dart';

class FloatingAdhkarCounts extends Equatable {
  const FloatingAdhkarCounts({
    required this.builtInCount,
    required this.customTotalCount,
    required this.customEnabledCount,
  });

  final int builtInCount;
  final int customTotalCount;
  final int customEnabledCount;

  @override
  List<Object?> get props => [
        builtInCount,
        customTotalCount,
        customEnabledCount,
      ];
}

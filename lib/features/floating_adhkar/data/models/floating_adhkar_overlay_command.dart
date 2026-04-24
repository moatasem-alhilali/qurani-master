import 'dart:convert';

enum FloatingAdhkarOverlayCommandType {
  reload,
  previewNow,
}

class FloatingAdhkarOverlayCommand {
  const FloatingAdhkarOverlayCommand({
    required this.type,
  });

  factory FloatingAdhkarOverlayCommand.fromEncoded(String raw) {
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final type = FloatingAdhkarOverlayCommandType.values.firstWhere(
      (item) => item.name == decoded['type'],
      orElse: () => FloatingAdhkarOverlayCommandType.reload,
    );

    return FloatingAdhkarOverlayCommand(type: type);
  }

  final FloatingAdhkarOverlayCommandType type;

  String encode() => jsonEncode({'type': type.name});
}

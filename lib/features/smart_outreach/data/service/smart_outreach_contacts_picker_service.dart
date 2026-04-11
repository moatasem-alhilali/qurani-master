import 'package:flutter_contacts/flutter_contacts.dart';

class SmartOutreachPickedContact {
  const SmartOutreachPickedContact({
    required this.name,
    required this.phoneNumbers,
  });

  final String name;
  final List<String> phoneNumbers;
}

enum SmartOutreachContactPickerFailure {
  permissionDenied,
  noPhoneNumbers,
  unknown,
}

class SmartOutreachContactPickerResult {
  const SmartOutreachContactPickerResult._({
    this.contact,
    this.failure,
    this.cancelled = false,
  });

  factory SmartOutreachContactPickerResult.success(
    SmartOutreachPickedContact contact,
  ) {
    return SmartOutreachContactPickerResult._(contact: contact);
  }

  factory SmartOutreachContactPickerResult.cancelled() {
    return const SmartOutreachContactPickerResult._(cancelled: true);
  }

  factory SmartOutreachContactPickerResult.failed(
    SmartOutreachContactPickerFailure failure,
  ) {
    return SmartOutreachContactPickerResult._(failure: failure);
  }

  final SmartOutreachPickedContact? contact;
  final SmartOutreachContactPickerFailure? failure;
  final bool cancelled;

  bool get isSuccess => contact != null;

  String? get errorMessage {
    switch (failure) {
      case SmartOutreachContactPickerFailure.permissionDenied:
        return 'يجب السماح بالوصول لجهات الاتصال لاختيار رقم تلقائياً.';
      case SmartOutreachContactPickerFailure.noPhoneNumbers:
        return 'جهة الاتصال المختارة لا تحتوي على رقم هاتف.';
      case SmartOutreachContactPickerFailure.unknown:
        return 'حدث خطأ أثناء اختيار جهة الاتصال.';
      case null:
        return null;
    }
  }
}

class SmartOutreachContactsPickerService {
  Future<SmartOutreachContactPickerResult> pickContact() async {
    try {
      final pickedId = await FlutterContacts.native.showPicker();
      if (pickedId == null || pickedId.trim().isEmpty) {
        return SmartOutreachContactPickerResult.cancelled();
      }

      var contact = await _loadContactWithPhones(pickedId);
      if (contact == null || contact.phones.isEmpty) {
        final permissionStatus = await FlutterContacts.permissions.request(
          PermissionType.read,
        );

        if (permissionStatus != PermissionStatus.granted &&
            permissionStatus != PermissionStatus.limited) {
          return SmartOutreachContactPickerResult.failed(
            SmartOutreachContactPickerFailure.permissionDenied,
          );
        }

        contact = await _loadContactWithPhones(pickedId);
      }

      if (contact == null || contact.phones.isEmpty) {
        return SmartOutreachContactPickerResult.failed(
          SmartOutreachContactPickerFailure.noPhoneNumbers,
        );
      }

      final uniqueNumbers = <String>[];
      for (final phone in contact.phones) {
        final raw = phone.number.trim();
        if (raw.isEmpty || uniqueNumbers.contains(raw)) {
          continue;
        }
        uniqueNumbers.add(raw);
      }

      if (uniqueNumbers.isEmpty) {
        return SmartOutreachContactPickerResult.failed(
          SmartOutreachContactPickerFailure.noPhoneNumbers,
        );
      }

      return SmartOutreachContactPickerResult.success(
        SmartOutreachPickedContact(
          name: _resolveContactName(contact),
          phoneNumbers: uniqueNumbers,
        ),
      );
    } catch (_) {
      return SmartOutreachContactPickerResult.failed(
        SmartOutreachContactPickerFailure.unknown,
      );
    }
  }

  Future<Contact?> _loadContactWithPhones(String id) {
    return FlutterContacts.get(
      id,
      properties: const {
        ContactProperty.name,
        ContactProperty.phone,
      },
    );
  }

  String _resolveContactName(Contact contact) {
    final first = (contact.name?.first ?? '').trim();
    final last = (contact.name?.last ?? '').trim();
    final merged = [first, last].where((part) => part.isNotEmpty).join(' ');
    if (merged.isNotEmpty) {
      return merged;
    }

    final display = (contact.displayName ?? '').trim();
    if (display.isNotEmpty) {
      return display;
    }

    return 'بدون اسم';
  }
}

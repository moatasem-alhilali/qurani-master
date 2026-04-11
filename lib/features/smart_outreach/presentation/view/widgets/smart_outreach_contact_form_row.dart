import 'package:flutter/material.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_contact_model.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_enums.dart';

class SmartOutreachContactFormRow {
  SmartOutreachContactFormRow({
    required this.id,
    required this.nameController,
    required this.phoneController,
    required this.smsTemplateController,
    required this.actionType,
  });

  factory SmartOutreachContactFormRow.empty() {
    return SmartOutreachContactFormRow(
      id: null,
      nameController: TextEditingController(),
      phoneController: TextEditingController(),
      smsTemplateController: TextEditingController(),
      actionType: SmartOutreachActionType.callOnly,
    );
  }

  factory SmartOutreachContactFormRow.fromContact(
    SmartOutreachContactModel contact,
  ) {
    return SmartOutreachContactFormRow(
      id: contact.id,
      nameController: TextEditingController(text: contact.name ?? ''),
      phoneController: TextEditingController(text: contact.phone),
      smsTemplateController:
          TextEditingController(text: contact.smsTemplate ?? ''),
      actionType: contact.actionType,
    );
  }

  factory SmartOutreachContactFormRow.prefilled({
    required String name,
    required String phone,
  }) {
    return SmartOutreachContactFormRow(
      id: null,
      nameController: TextEditingController(text: name.trim()),
      phoneController: TextEditingController(text: phone.trim()),
      smsTemplateController: TextEditingController(),
      actionType: SmartOutreachActionType.callOnly,
    );
  }

  final int? id;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController smsTemplateController;
  SmartOutreachActionType actionType;

  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    smsTemplateController.dispose();
  }
}

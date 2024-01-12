import 'package:jagadis/common/services/utility_service.dart';
import 'package:jagadis/sos/components/card_body_component.dart';
import 'package:jagadis/sos/components/remove_guardian_dialog_component.dart';
import 'package:flutter/material.dart';

class GuardianCardComponent extends StatelessWidget {
  const GuardianCardComponent(
      {super.key,
      required this.phoneNumber,
      this.name,
      required this.id,
      required this.action});

  final String id;
  final String phoneNumber;
  final String? name;
  final Function action;

  @override
  Widget build(BuildContext context) {
    return CardBodyComponent(
        info: UtilityService.formatPhoneNumber(phoneNumber),
        name: name,
        action: IconButton(
          onPressed: () => showDialog(
              context: context,
              builder: (context) => RemoveGuardianDialogComponent(
                  action: action,
                  guardianId: id,
                  guardianInfo: name ?? phoneNumber)),
          icon: const Icon(
            Icons.remove_circle,
            color: Color(0xFFE74D5F),
            size: 24,
          ),
        ));
  }
}

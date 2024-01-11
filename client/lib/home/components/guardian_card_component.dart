import 'package:client/common/services/utility_service.dart';
import 'package:client/home/components/card_body_component.dart';
import 'package:flutter/material.dart';

class GuardianCardComponent extends StatelessWidget {
  const GuardianCardComponent(
      {super.key, required this.phoneNumber, this.name, required this.id});

  final String id;
  final String phoneNumber;
  final String? name;

  @override
  Widget build(BuildContext context) {
    return CardBodyComponent(
        info: UtilityService.formatPhoneNumber(phoneNumber),
        name: name,
        action: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.remove_circle,
            color: Color(0xFFE74D5F),
            size: 24,
          ),
        ));
  }
}

import 'package:client/home/components/card_body_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';

class GuardianCardComponent extends StatelessWidget {
  const GuardianCardComponent(
      {super.key, required this.phoneNumber, this.name, required this.id});

  final String id;
  final String phoneNumber;
  final String? name;

  @override
  Widget build(BuildContext context) {
    return CardBodyComponent(
        info: formatNumberSync(phoneNumber),
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

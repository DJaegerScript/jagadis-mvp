import 'package:client/home/components/card_body_component.dart';
import 'package:flutter/material.dart';

// TODO: create parameter
class GuardianCardComponent extends StatelessWidget {
  const GuardianCardComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return CardBodyComponent(
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

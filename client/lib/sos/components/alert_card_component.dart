import 'package:jagadis/common/services/utility_service.dart';
import 'package:jagadis/sos/components/card_body_component.dart';
import 'package:flutter/material.dart';

class AlertCardComponent extends StatelessWidget {
  const AlertCardComponent(
      {super.key,
      required this.activatedAt,
      this.name,
      required this.phoneNumber,
      required this.id});

  final DateTime activatedAt;
  final String? name;
  final String phoneNumber;
  final String id;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {},
      child: CardBodyComponent(
          name: name ?? UtilityService.formatPhoneNumber(phoneNumber),
          info: UtilityService.formatDate(activatedAt),
          action: const Icon(Icons.arrow_forward, size: 24)),
    );
  }
}

import 'package:client/home/components/card_body_component.dart';
import 'package:flutter/material.dart';

class AlertCardComponent extends StatelessWidget {
  const AlertCardComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {},
      child:
          const CardBodyComponent(action: Icon(Icons.arrow_forward, size: 24)),
    );
  }
}

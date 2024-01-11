import 'package:client/home/components/alert_card_component.dart';
import 'package:flutter/material.dart';

class AlertListScreen extends StatelessWidget {
  const AlertListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsetsDirectional.only(top: 16, end: 16, start: 16),
      child: SingleChildScrollView(
        child: Column(children: [
          AlertCardComponent(),
          AlertCardComponent(),
          AlertCardComponent(),
          AlertCardComponent(),
          AlertCardComponent(),
          AlertCardComponent(),
          AlertCardComponent(),
          AlertCardComponent(),
          AlertCardComponent(),
          AlertCardComponent(),
          AlertCardComponent(),
          AlertCardComponent(),
          AlertCardComponent(),
          AlertCardComponent(),
          AlertCardComponent(),
          AlertCardComponent(),
          AlertCardComponent(),
          AlertCardComponent(),
          AlertCardComponent(),
          AlertCardComponent(),
          AlertCardComponent(),
          AlertCardComponent(),
        ]),
      ),
    );
  }
}

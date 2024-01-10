import 'package:flutter/cupertino.dart';

class ActivateStandbyModeTitle extends StatelessWidget {
  const ActivateStandbyModeTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: const TextSpan(children: [
      TextSpan(
          text: "Aktifkan Mode ", style: TextStyle(color: Color(0xFF170015))),
      TextSpan(text: "Stand By", style: TextStyle(color: Color(0xFFFF5C97))),
    ], style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)));
  }
}

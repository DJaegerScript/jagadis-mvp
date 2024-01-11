import 'package:flutter/cupertino.dart';

class ActivateStandbyModeTitle extends StatelessWidget {
  const ActivateStandbyModeTitle({super.key, required this.isStandby});

  final bool isStandby;

  @override
  Widget build(BuildContext context) {
    var textSpans = [
      TextSpan(
          text: "${isStandby ? "" : "Aktifkan"} Mode ",
          style: const TextStyle(color: Color(0xFF170015))),
      const TextSpan(
          text: "Stand By", style: TextStyle(color: Color(0xFFFF5C97))),
    ];

    if (isStandby) {
      textSpans.add(const TextSpan(
          text: " Telah Aktif ", style: TextStyle(color: Color(0xFF170015))));
    }

    return RichText(
        text: TextSpan(
            children: textSpans,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)));
  }
}

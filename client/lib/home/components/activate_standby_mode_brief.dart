import 'package:flutter/cupertino.dart';

class ActivateStandbyModeBrief extends StatelessWidget {
  const ActivateStandbyModeBrief({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
        textAlign: TextAlign.center,
        text: const TextSpan(children: [
          TextSpan(
              text:
                  "Ponsel Anda akan berjaga, menyalakan alarm, dan mengirimkan sinyal SOS ketika tombol ",
              style: TextStyle(color: Color(0xFF170015))),
          TextSpan(
              text:
                  "power ditekan sebanyak 3 kali berturut-turut pada perangkat anda",
              style: TextStyle(color: Color(0xFFFF5C97))),
        ], style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)));
  }
}

import 'package:flutter/cupertino.dart';

class ActivateStandbyModeBrief extends StatelessWidget {
  const ActivateStandbyModeBrief({super.key, required this.isStandby});

  final bool isStandby;

  @override
  Widget build(BuildContext context) {
    return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: [
          TextSpan(
              text: isStandby
                  ? "Tekan tombol power 3 kali berturut-turut pada perangkat kamu "
                  : "Ponsel kamu akan berjaga, menyalakan alarm, dan mengirimkan sinyal SOS ketika tombol ",
              style:
                  TextStyle(color: Color(isStandby ? 0xFFFF5C97 : 0xFF170015))),
          TextSpan(
              text: isStandby
                  ? "untuk mengaktifkan alarm dan mengirimkan sinyal SOS dalam sekejap."
                  : "power ditekan sebanyak 3 kali berturut-turut pada perangkat kamu",
              style:
                  TextStyle(color: Color(isStandby ? 0xFF170015 : 0xFFFF5C97))),
        ], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)));
  }
}

import 'package:jagadis/sos/view_models/sos_view_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ActivateStandbyModeBrief extends StatelessWidget {
  const ActivateStandbyModeBrief({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SOSViewModel>(builder: (context, viewModel, child) {
      return RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              children: [
                TextSpan(
                    text: viewModel.isStandby
                        ? "Tekan tombol power 3 kali berturut-turut pada perangkat kamu "
                        : "Ponsel kamu akan berjaga, menyalakan alarm, dan mengirimkan sinyal SOS ketika tombol ",
                    style: TextStyle(
                        color: Color(
                            viewModel.isStandby ? 0xFFFF5C97 : 0xFF170015))),
                TextSpan(
                    text: viewModel.isStandby
                        ? "untuk mengaktifkan alarm dan mengirimkan sinyal SOS dalam sekejap."
                        : "power ditekan sebanyak 3 kali berturut-turut pada perangkat kamu",
                    style: TextStyle(
                        color: Color(
                            viewModel.isStandby ? 0xFF170015 : 0xFFFF5C97))),
              ],
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)));
    });
  }
}

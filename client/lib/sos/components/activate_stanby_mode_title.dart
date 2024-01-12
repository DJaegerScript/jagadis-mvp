import 'package:jagadis/sos/view_models/sos_view_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ActivateStandbyModeTitle extends StatelessWidget {
  const ActivateStandbyModeTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SOSViewModel>(
      builder: (context, viewModel, child) {
        List<TextSpan> textSpans = [
          TextSpan(
              text: "${viewModel.isStandby ? "" : "Aktifkan"} Mode ",
              style: const TextStyle(color: Color(0xFF170015))),
          const TextSpan(
              text: "Stand By", style: TextStyle(color: Color(0xFFFF5C97))),
        ];

        if (viewModel.isStandby) {
          textSpans.add(const TextSpan(
              text: " Telah Aktif ",
              style: TextStyle(color: Color(0xFF170015))));
        }

        return RichText(
            text: TextSpan(
                children: textSpans,
                style: const TextStyle(
                    fontSize: 24, fontWeight: FontWeight.w700)));
      },
    );
  }
}

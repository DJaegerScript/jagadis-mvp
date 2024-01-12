import 'package:jagadis/sos/components/reset_guardian_dialog_component.dart';
import 'package:jagadis/sos/view_models/guardian_view_models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetGuardianComponent extends StatelessWidget {
  const ResetGuardianComponent({super.key, required this.isExpanded});

  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    return Consumer<GuardianViewModel>(builder: (context, viewModel, child) {
      return Transform.translate(
        offset: Offset(0, !isExpanded ? 100 : 0),
        child: Align(
          alignment: AlignmentDirectional.bottomCenter,
          child: Container(
              margin: const EdgeInsetsDirectional.only(bottom: 24),
              width: 155,
              height: 40,
              decoration: BoxDecoration(
                  color: const Color(0xFFFCE8F2),
                  borderRadius: BorderRadius.circular(100)),
              child: TextButton(
                  onPressed: () => showDialog(
                      context: context,
                      builder: (context) => ResetGuardianDialogComponent(
                            action: viewModel.refreshGuardians,
                          )),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.delete,
                        size: 24,
                        color: Color(0xFFE74D5F),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Hapus Semua",
                        style: TextStyle(
                          color: Color(0xFFE74D5F),
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ))),
        ),
      );
    });
  }
}

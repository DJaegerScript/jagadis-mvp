import 'package:jagadis/sos/components/add_guardian_dialog_component.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class EmptyGuardianCardComponent extends StatelessWidget {
  const EmptyGuardianCardComponent({super.key, required this.action});

  final Function action;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (context) => AddGuardianDialogComponent(
                    action: action,
                  ));
        },
        child: DottedBorder(
          color: const Color(0xFF79747E),
          dashPattern: const [8, 4],
          strokeWidth: 2,
          strokeCap: StrokeCap.round,
          borderType: BorderType.RRect,
          radius: const Radius.circular(8),
          child: Container(
            height: 72,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFFF5F2F5)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.add,
                  size: 24,
                  color: Color(0xFFFF5C97),
                ),
                RichText(
                    text: const TextSpan(
                        style: TextStyle(
                            color: Color(0xFF170015),
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                        children: [
                      TextSpan(text: "Tambahkan "),
                      TextSpan(
                          text: "orang",
                          style: TextStyle(
                              color: Color(0xFFFF5C97),
                              decoration: TextDecoration.underline)),
                      TextSpan(text: " yang kamu percaya!")
                    ]))
              ],
            ),
          ),
        ));
  }
}

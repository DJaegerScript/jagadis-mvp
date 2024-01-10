import 'package:client/common/components/text_field_component.dart';
import 'package:client/guardian/models/get_all_guardian_response.dart';
import 'package:flutter/material.dart';

class GuardianContactComponent extends StatefulWidget {
  const GuardianContactComponent({super.key, this.guardian});

  final Guardian? guardian;

  @override
  State<StatefulWidget> createState() => _GuardianContactComponentState();
}

class _GuardianContactComponentState extends State<GuardianContactComponent> {
  final _guardianContactKey = GlobalKey<FormState>();

  String _contactNumber = "";

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: TextFieldComponent(
                initialValue: widget.guardian?.contactNumber,
                labelText: "Guardian",
                action: (String? value) {
                  setState(() {
                    _contactNumber = value!;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Guardian contact cannot be empty!';
                  }
                  return null;
                })
        ),
        IconButton(
            onPressed: () {
              print("test");
            },
            icon: const Icon(
                Icons.check
            )
        )
      ],
    );
  }
}
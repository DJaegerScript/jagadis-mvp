import 'package:client/common/components/text_field_component.dart';
import 'package:client/common/models/common_response.dart';
import 'package:client/home/view_models/guardian_view_models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddGuardianDialogComponent extends StatefulWidget {
  const AddGuardianDialogComponent({super.key});

  @override
  State<StatefulWidget> createState() => _AddGuardianDialogComponent();
}

class _AddGuardianDialogComponent extends State<AddGuardianDialogComponent> {
  final _addContactNumberForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GuardianViewModel(),
      child: Consumer<GuardianViewModel>(
        builder: (context, viewModel, child) {
          return AlertDialog(
            title: const Text("Tambahkan Penerima Sinyal SOS",
                style: TextStyle(color: Color(0xFF170015), fontSize: 16)),
            content: Form(
              key: _addContactNumberForm,
              child: TextFieldComponent(
                  keyboardType: TextInputType.phone,
                  labelText: "No. Handphone",
                  hintText: "No. Handphone",
                  action: (String? value) =>
                      value != null ? viewModel.setPhoneNumber(value) : null,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Phone number cannot be empty";
                    } else if (!value.startsWith("+62") &&
                        !value.startsWith("62") &&
                        !value.startsWith("0")) {
                      return 'Phone number is invalid!';
                    }
                    return null;
                  }),
            ),
            actions: [
              TextButton(
                  onPressed: viewModel.isLoading
                      ? null
                      : () {
                          Navigator.of(context).pop();
                        },
                  child: const Text(
                    "Batalkan",
                    style: TextStyle(color: Color(0xFFE74D5F)),
                  )),
              TextButton(
                onPressed: viewModel.isLoading
                    ? null
                    : () async {
                        if (_addContactNumberForm.currentState?.validate() ??
                            false) {
                          Future.delayed(Duration.zero).then(
                              (value) => {FocusScope.of(context).unfocus()});

                          viewModel.setLoading(true);

                          CommonResponse response =
                              await viewModel.addGuardian();

                          Future.delayed(Duration.zero).then((value) => {
                                Navigator.of(context).pop(),
                                FocusScope.of(context).unfocus()
                              });

                          if (response.isSuccess) {
                            Future.delayed(Duration.zero).then((value) =>
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Penerima sinyal berhasil ditambahkan!'),
                                  ),
                                ));
                          } else {
                            Future.delayed(Duration.zero).then((value) =>
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(response.message),
                                  ),
                                ));
                          }
                          viewModel.setLoading(false);
                        }
                      },
                style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFFF5C97)),
                child: viewModel.isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : const Text("Tambahkan",
                        style: TextStyle(color: Colors.white)),
              )
            ],
          );
        },
      ),
    );
  }
}

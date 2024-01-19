import 'package:flutter/material.dart';
import 'package:jagadis/authentication/view_models/authentication_view_model.dart';
import 'package:jagadis/common/components/text_field_component.dart';
import 'package:provider/provider.dart';

class RegistrationFormComponent extends StatefulWidget {
  const RegistrationFormComponent({super.key});

  @override
  State<StatefulWidget> createState() => _RegistrationFormComponentState();
}

class _RegistrationFormComponentState extends State<RegistrationFormComponent> {
  final _registrationFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationViewModel>(
      builder: (context, viewModel, child) {
        return Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
          child: Form(
              key: _registrationFormKey,
              child: Column(
                children: [
                  TextFieldComponent(
                      labelText: "Email",
                      keyboardType: TextInputType.emailAddress,
                      hintText: "jane.doe@mail.com",
                      action: (String? value) =>
                          value != null ? viewModel.setEmail(value) : null,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Email tidak boleh kosong!";
                        }
                        return null;
                      }),
                  const SizedBox(
                    height: 14,
                  ),
                  TextFieldComponent(
                    keyboardType: TextInputType.phone,
                    labelText: "No. Handphone",
                    hintText: "851xxxxxxxx",
                    action: (String? value) =>
                        value != null ? viewModel.setPhoneNumber(value) : null,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Nomor handphone tidak boleh kosong!";
                      }
                      return null;
                    },
                    isForPhone: true,
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  TextFieldComponent(
                      isTextObscured: true,
                      labelText: "Password",
                      hintText: "Masukkan password yang diinginkan!",
                      action: (String? value) =>
                          value != null ? viewModel.setPassword(value) : null,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Password tidak boleh kosong!";
                        }
                        return null;
                      }),
                  const SizedBox(
                    height: 14,
                  ),
                  TextFieldComponent(
                      isTextObscured: true,
                      labelText: "Konfirmasi Password",
                      hintText: "Masukkan ulang password mu!",
                      action: (String? value) => value != null
                          ? viewModel.setConfirmationPassword(value)
                          : null,
                      validator: (String? value) {
                        print(value);
                        print(viewModel.getPassword());
                        if (value == null ||
                            value.isEmpty ||
                            value != viewModel.getPassword()) {
                          return "Password tidak sama!";
                        }
                        return null;
                      }),
                  const SizedBox(
                    height: 28,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (_registrationFormKey.currentState!.validate()) {
                          viewModel.register();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF5C96),
                          minimumSize:
                              Size(MediaQuery.of(context).size.width, 60),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(60))),
                      child: const Text(
                        "Daftar",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      )),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              )),
        );
      },
    );
  }
}

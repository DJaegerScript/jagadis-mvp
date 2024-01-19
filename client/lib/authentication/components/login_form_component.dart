import 'package:flutter/material.dart';
import 'package:jagadis/authentication/view_models/authentication_view_model.dart';
import 'package:jagadis/common/components/text_field_component.dart';
import 'package:provider/provider.dart';

class LoginFormComponent extends StatefulWidget {
  const LoginFormComponent({super.key});

  @override
  State<StatefulWidget> createState() => _LoginFormComponentState();
}

class _LoginFormComponentState extends State<LoginFormComponent> {
  final _loginFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationViewModel>(
      builder: (context, viewModel, child) {
        return Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
          child: Form(
              key: _loginFormKey,
              child: Column(
                children: [
                  Container(
                      alignment: Alignment.topLeft,
                      child: const Text("Email",
                          style: TextStyle(
                              color: Color(0xFF170015),
                              fontSize: 14,
                              fontWeight: FontWeight.bold))),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFieldComponent(
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
                    height: 24,
                  ),
                  Container(
                      alignment: Alignment.topLeft,
                      child: const Text("Password",
                          style: TextStyle(
                              color: Color(0xFF170015),
                              fontSize: 14,
                              fontWeight: FontWeight.bold))),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFieldComponent(
                      hintText: "Masukkan password mu!",
                      isTextObscured: true,
                      action: (String? value) =>
                          value != null ? viewModel.setPassword(value) : null,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Password tidak boleh kosong!";
                        }
                        return null;
                      }),
                  const SizedBox(
                    height: 40,
                  ),
                  ElevatedButton(
                      onPressed: viewModel.login,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF5C96),
                          minimumSize:
                              Size(MediaQuery.of(context).size.width, 60),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(60))),
                      child: const Text(
                        "Masuk",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      )),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text("Atau masuk dengan",
                      style: TextStyle(
                        color: Color(0xFF79747E),
                        fontSize: 16,
                      )),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton.icon(
                    onPressed: viewModel.login,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        minimumSize:
                            Size(MediaQuery.of(context).size.width, 60),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(60),
                            side: const BorderSide(color: Colors.black54))),
                    icon: const Image(
                        image: AssetImage("assets/images/google_PNG19635.png"),
                        width: 24,
                        height: 24),
                    label: const Text(
                      "Google",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
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

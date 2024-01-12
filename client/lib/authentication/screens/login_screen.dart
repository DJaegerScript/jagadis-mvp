import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jagadis/authentication/models/login_response.dart';
import 'package:jagadis/authentication/services/authentication_service.dart';
import 'package:jagadis/common/components/text_field_component.dart';
import 'package:jagadis/common/models/common_response.dart';
import 'package:jagadis/common/services/secure_storage_service.dart';
import 'package:jagadis/sos/screens/home_screen.dart';

import 'registration_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginFormKey = GlobalKey<FormState>();

  String _email = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        child: Center(
          child: Form(
            key: _loginFormKey,
            child: Column(
              children: [
                Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const RegistrationScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Daftar",
                            style: TextStyle(
                              color: Color(0xFFFF5C96),
                              fontSize: 14,
                            ),
                          )),
                    )),
                const SizedBox(
                  height: 4,
                ),
                Stack(
                  children: [
                    const Column(
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topStart,
                          child: Image(
                              image:
                                  AssetImage("assets/images/logo_jagadis.png"),
                              width: 250,
                              height: 250,
                              fit: BoxFit.cover),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const SizedBox(
                          height: 170,
                        ),
                        Container(
                            alignment: Alignment.topLeft,
                            margin: const EdgeInsets.only(left: 20, right: 20),
                            child: RichText(
                                text: const TextSpan(
                                    text: "Selamat datang di ",
                                    style: TextStyle(
                                        color: Color(0xFF170015),
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                    children: [
                                  TextSpan(
                                    text: "JaGadis",
                                    style: TextStyle(
                                        color: Color(0xFFFF5C96),
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  )
                                ]))),
                        const SizedBox(
                          height: 2,
                        ),
                        Container(
                            alignment: Alignment.topLeft,
                            margin: const EdgeInsets.only(left: 20, right: 20),
                            child: const Text(
                                "Bersiaplah melindungi diri Anda. Atur tombol darurat dan gunakan fitur preventif!",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ))),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: [
                      Container(
                          alignment: Alignment.topLeft,
                          child: const Text("Email/Username",
                              style: TextStyle(
                                  color: Color(0xFF170015),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold))),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFieldComponent(
                          keyboardType: TextInputType.emailAddress,
                          labelText: "Email/Username",
                          hintText: "Email/Username",
                          action: (String? value) {
                            setState(() {
                              _email = value!;
                            });
                          },
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Email or username cannot be empty";
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
                          isTextObscured: true,
                          labelText: "Password",
                          action: (String? value) {
                            setState(() {
                              _password = value!;
                            });
                          },
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Password cannot be empty";
                            }
                            return null;
                          }),
                      const SizedBox(
                        height: 40,
                      ),
                      ElevatedButton(
                          onPressed: _login,
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
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            minimumSize:
                                Size(MediaQuery.of(context).size.width, 60),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(60),
                                side: const BorderSide(color: Colors.black54))),
                        icon: const Image(
                            image:
                                AssetImage("assets/images/google_PNG19635.png"),
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
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }

  void _login() async {
    if (_loginFormKey.currentState!.validate()) {
      Map<String, String> body = {
        "email": _email,
        "password": _password,
      };

      CommonResponse<LoginResponse> response =
          await AuthenticationService.loginUser(body);

      if (response.isSuccess) {
        await SecureStorageService.write(
            "token", response.content?.token ?? "");
        await SecureStorageService.write(
            "user",
            response.content?.user != null
                ? jsonEncode(response.content?.user)
                : "");

        Future.delayed(Duration.zero).then(
            (value) => Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                )));
      } else {
        Future.delayed(Duration.zero).then((value) =>
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(response.message))));
      }
    }
  }
}

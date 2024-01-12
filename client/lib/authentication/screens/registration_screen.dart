import 'package:jagadis/authentication/screens/login_screen.dart';
import 'package:jagadis/authentication/services/authentication_service.dart';
import 'package:jagadis/common/components/text_field_component.dart';
import 'package:jagadis/common/models/common_response.dart';
import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _registrationFormKey = GlobalKey<FormState>();

  String _phoneNumber = "";
  String _email = "";
  String _confirmationPassword = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        child: Center(
          child: Form(
            key: _registrationFormKey,
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
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Masuk",
                            style: TextStyle(
                              color: Colors.pinkAccent,
                              fontSize: 16,
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
                                        color: Colors.black,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                    children: [
                                  TextSpan(
                                    text: "JaGadis",
                                    style: TextStyle(
                                        color: Colors.pinkAccent,
                                        fontSize: 24,
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
                                "Daftar sekarang dan ambil langkah pertama menuju keamanan!",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ))),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 14,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: [
                      Container(
                          alignment: Alignment.topLeft,
                          child: const Text("Email",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold))),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFieldComponent(
                          keyboardType: TextInputType.emailAddress,
                          labelText: "Email",
                          hintText: "Email",
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
                        height: 14,
                      ),
                      Container(
                          alignment: Alignment.topLeft,
                          child: const Text("No. HP",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold))),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFieldComponent(
                          keyboardType: TextInputType.phone,
                          labelText: "No. HP",
                          hintText: "No. HP",
                          action: (String? value) {
                            setState(() {
                              _phoneNumber = value!;
                            });
                          },
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Phone number cannot be empty";
                            } else if (!_phoneNumber.startsWith("+62") &&
                                !_phoneNumber.startsWith("62") &&
                                !_phoneNumber.startsWith("0")) {
                              return 'Phone number is invalid!';
                            }
                            return null;
                          }),
                      const SizedBox(
                        height: 14,
                      ),
                      Container(
                          alignment: Alignment.topLeft,
                          child: const Text("Password",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
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
                        height: 14,
                      ),
                      Container(
                          alignment: Alignment.topLeft,
                          child: const Text("Konfirmasi Password",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold))),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFieldComponent(
                          isTextObscured: true,
                          labelText: "Konfirmasi Password",
                          action: (String? value) {
                            setState(() {
                              _confirmationPassword = value!;
                            });
                          },
                          validator: (String? value) {
                            if (value == null ||
                                value.isEmpty ||
                                _confirmationPassword != _password) {
                              return "Enter the same password as before, for verification";
                            }
                            return null;
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          onPressed: _register,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pinkAccent,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          child: const Text(
                            "Daftar",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )),
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

  void _register() async {
    if (_registrationFormKey.currentState!.validate()) {
      String formattedPhoneNumber = _phoneNumber.startsWith("62")
          ? "+$_phoneNumber"
          : _phoneNumber.startsWith("0")
              ? _phoneNumber.replaceFirst("0", "+62")
              : _phoneNumber;

      Map<String, String> body = {
        "phoneNumber": formattedPhoneNumber,
        "email": _email,
        "password": _password,
        "confirmationPassword": _confirmationPassword
      };

      CommonResponse response = await AuthenticationService.registerUser(body);

      if (response.isSuccess) {
        Future.delayed(Duration.zero).then(
            (value) => Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                )));
      } else {
        Future.delayed(Duration.zero).then((value) =>
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(response.message))));
      }
    }
  }
}

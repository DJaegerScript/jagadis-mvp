import 'package:flutter/material.dart';
import 'package:jagadis/authentication/components/auth_header_component.dart';
import 'package:jagadis/authentication/components/auth_menu_component.dart';
import 'package:jagadis/authentication/components/registration_form_component.dart';
import 'package:jagadis/authentication/screens/login_screen.dart';
import 'package:jagadis/authentication/view_models/authentication_view_model.dart';
import 'package:provider/provider.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthenticationViewModel(),
      child: const Scaffold(
          body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              AuthMenuComponent(label: "Masuk", screen: LoginScreen()),
              SizedBox(
                height: 4,
              ),
              AuthHeaderComponent(
                  text:
                      "Daftar sekarang dan ambil langkah pertama menuju keamanan!"),
              SizedBox(
                height: 24,
              ),
              RegistrationFormComponent(),
            ],
          ),
        ),
      )),
    );
  }
}

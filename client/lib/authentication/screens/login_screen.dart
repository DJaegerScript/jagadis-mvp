import 'package:flutter/material.dart';
import 'package:jagadis/authentication/components/auth_header_component.dart';
import 'package:jagadis/authentication/components/auth_menu_component.dart';
import 'package:jagadis/authentication/components/login_form_component.dart';
import 'package:jagadis/authentication/view_models/authentication_view_model.dart';
import 'package:provider/provider.dart';

import 'registration_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthenticationViewModel(),
      child: const Scaffold(
          body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              AuthMenuComponent(label: "Daftar", screen: RegistrationScreen()),
              SizedBox(
                height: 4,
              ),
              AuthHeaderComponent(
                  text:
                      "Bersiaplah melindungi diri Anda. Atur tombol darurat dan gunakan fitur preventif!"),
              SizedBox(
                height: 24,
              ),
              LoginFormComponent(),
            ],
          ),
        ),
      )),
    );
  }
}

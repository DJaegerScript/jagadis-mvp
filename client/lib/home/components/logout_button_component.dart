import 'package:client/authentication/screens/login_screen.dart';
import 'package:client/authentication/services/authentication_service.dart';
import 'package:client/common/services/secure_storage_service.dart';
import 'package:flutter/material.dart';

class LogoutButtonComponent extends StatelessWidget {
  const LogoutButtonComponent({super.key});

  @override
  Widget build(BuildContext context) {
    void deleteButtonPressed() async {
      await AuthenticationService.logoutUser();
      await SecureStorageService.destroyAll();

      Future.delayed(Duration.zero).then((value) =>
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          )));
    }

    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white24,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)),
        ),
        onPressed: deleteButtonPressed,
        child: const Text(
          'Logout',
          style: TextStyle(fontSize: 20),
        ));
  }
}
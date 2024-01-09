
import 'package:client/common/services/secure_storage_service.dart';
import 'package:client/guardian/screens/guardian_list_screen.dart';
import 'package:client/home/components/logout_button_component.dart';
import 'package:flutter/material.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: SecureStorageService.read("token"),
        builder:  (BuildContext context, AsyncSnapshot<String?> snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return  Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GuardianListScreen(),
                        ));
                  }, 
                      child: const Text("Guardians")),
                  const LogoutButtonComponent()
                ],
              )
            );
          }
        },
    );
  }
}

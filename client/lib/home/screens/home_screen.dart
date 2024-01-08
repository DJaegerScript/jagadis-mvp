
import 'package:client/common/services/secure_storage_service.dart';
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
            return const Center(
              child: LogoutButtonComponent()
            );
          }
        },
    );
  }
}
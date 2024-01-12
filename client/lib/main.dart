import 'dart:async';

import 'package:jagadis/common/services/background_service.dart';
import 'package:jagadis/sos/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'authentication/screens/login_screen.dart';
import 'authentication/services/authentication_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BackgroundService.initializeService();
  initializeDateFormatting("id_ID", null).then((_) {
    runApp(const App());
  });
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'JaGadis',
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: FutureBuilder(
          future: AuthenticationService.isAuthenticated(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.data == null) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return snapshot.data! ? const HomeScreen() : const LoginScreen();
            }
          },
        ));
  }
}

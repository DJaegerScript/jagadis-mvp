import 'package:client/home/screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(const App());

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
        home: const SplashScreen());
  }
}

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:jagadis/common/services/background_service.dart';
import 'package:jagadis/sos/screens/splash_screen.dart';

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
        home: const SplashScreen());
  }
}

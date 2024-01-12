import 'dart:async';
import 'dart:ui';

import 'package:jagadis/common/services/utility_service.dart';
import 'package:jagadis/sos/view_models/sos_view_models.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';

class BackgroundService {
  static const notificationChannelId = 'my_foreground';

// this will be used for notification id, So you can update your custom notification with this id.
  static const notificationId = 888;

  static Future<void> initializeService() async {
    final service = FlutterBackgroundService();

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      notificationChannelId, // id
      'MY FOREGROUND SERVICE', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.low, // importance must be at low or higher level
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await service.configure(
        androidConfiguration: AndroidConfiguration(
          // this will be executed when app is in foreground or background in separated isolate
          onStart: onStart,

          // auto start service
          autoStart: false,
          isForegroundMode: true,

          notificationChannelId: notificationChannelId,
          // this must match with notification channel you created above.
          initialNotificationTitle: 'AWESOME SERVICE',
          initialNotificationContent: 'Initializing',
          foregroundServiceNotificationId: notificationId,
        ),
        iosConfiguration: IosConfiguration());
  }

  @pragma('vm:entry-point')
  static Future<void> onStart(ServiceInstance service) async {
    // Only available for flutter 3.0.0 and later
    DartPluginRegistrant.ensureInitialized();

    service.on('stopService').listen((event) async {
      await service.stopSelf();
    });

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    // bring to foreground
    Timer.periodic(const Duration(seconds: 10), (timer) async {
      if (service is AndroidServiceInstance) {
        if (await service.isForegroundService()) {
          await flutterLocalNotificationsPlugin.show(
            notificationId,
            'COOL SERVICE',
            'Awesome ${DateTime.now()}',
            const NotificationDetails(
              android: AndroidNotificationDetails(
                notificationChannelId,
                'MY FOREGROUND SERVICE',
                icon: 'ic_bg_service_small',
                ongoing: true,
              ),
            ),
          );

          Position position = await UtilityService.getCurrentPosition();

          await SOSViewModel().updateAlert(position, "TRACK");
        }
      }
    });
  }
}

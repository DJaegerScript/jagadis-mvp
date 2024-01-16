import 'package:flutter/material.dart';
import 'package:jagadis/common/services/secure_storage_service.dart';
import 'package:jagadis/sos/components/activate_stanby_mode_title.dart';
import 'package:jagadis/sos/components/activate_standby_mode_brief.dart';
import 'package:jagadis/sos/components/standby_switch_component.dart';
import 'package:jagadis/sos/view_models/sos_view_models.dart';
import 'package:provider/provider.dart';

class SOSScreen extends StatefulWidget {
  const SOSScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SOSScreenState();
}

class _SOSScreenState extends State<SOSScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: SecureStorageService.read("standbyStatus"),
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ChangeNotifierProvider(
              create: (context) =>
                  SOSViewModel(snapshot.data.toString() == "true", _controller),
              child: const Padding(
                padding: EdgeInsetsDirectional.symmetric(
                    horizontal: 16, vertical: 29),
                child: Column(
                  children: [
                    Column(
                      children: [
                        ActivateStandbyModeTitle(),
                        SizedBox(height: 8),
                        ActivateStandbyModeBrief()
                      ],
                    ),
                    SizedBox(
                      height: 70,
                    ),
                    StandbySwitchComponent()
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

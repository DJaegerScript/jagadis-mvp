import 'package:client/home/components/activate_stanby_mode_title.dart';
import 'package:client/home/components/activate_standby_mode_brief.dart';
import 'package:client/home/components/standby_switch_component.dart';
import 'package:flutter/cupertino.dart';

class SOSScreen extends StatelessWidget {
  const SOSScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 29),
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
    );
  }
}

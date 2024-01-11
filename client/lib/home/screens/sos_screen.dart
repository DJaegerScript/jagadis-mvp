import 'package:client/home/components/activate_stanby_mode_title.dart';
import 'package:client/home/components/activate_standby_mode_brief.dart';
import 'package:client/home/components/standby_switch_component.dart';
import 'package:flutter/cupertino.dart';

class SOSScreen extends StatefulWidget {
  const SOSScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SOSScreenState();
}

class _SOSScreenState extends State<SOSScreen> {
  bool _isStandby = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 29),
      child: Column(
        children: [
          Column(
            children: [
              ActivateStandbyModeTitle(
                isStandby: _isStandby,
              ),
              const SizedBox(height: 8),
              ActivateStandbyModeBrief(
                isStandby: _isStandby,
              )
            ],
          ),
          const SizedBox(
            height: 70,
          ),
          StandbySwitchComponent(
            isStandby: _isStandby,
            setStandby: () {
              setState(() {
                _isStandby = !_isStandby;
              });
            },
          )
        ],
      ),
    );
  }
}

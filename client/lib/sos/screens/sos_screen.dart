import 'package:client/sos/components/activate_stanby_mode_title.dart';
import 'package:client/sos/components/activate_standby_mode_brief.dart';
import 'package:client/sos/components/standby_switch_component.dart';
import 'package:client/sos/view_models/sos_view_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class SOSScreen extends StatefulWidget {
  const SOSScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SOSScreenState();
}

class _SOSScreenState extends State<SOSScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SOSViewModel(),
      child: const Padding(
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
      ),
    );
  }
}

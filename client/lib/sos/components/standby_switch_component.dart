import 'package:jagadis/common/services/utility_service.dart';
import 'package:jagadis/sos/view_models/sos_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class StandbySwitchComponent extends StatefulWidget {
  const StandbySwitchComponent({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _StandbySwitchComponentState();
}

class _StandbySwitchComponentState extends State<StandbySwitchComponent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _animation =
        Tween<double>(begin: 0, end: 246 - 246 * 0.5).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SOSViewModel>(
      builder: (context, viewModel, child) {
        return GestureDetector(
          onTap: () async {
            try {
              bool previousStandbyStatus = viewModel.isStandby;

              !viewModel.isStandby
                  ? _controller.forward()
                  : _controller.reverse();

              if (!viewModel.isStandby) {
                FlutterBackgroundService().startService();
              } else {
                FlutterBackgroundService().invoke("stopService", null);
              }

              viewModel.setIsStandby(!viewModel.isStandby);

              Position position = await UtilityService.getCurrentPosition();

              String message = !previousStandbyStatus
                  ? await viewModel.enterStandbyMode(position)
                  : await viewModel.updateAlert(position, "TURNED_OFF");

              Future.delayed(Duration.zero)
                  .then((value) => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(message),
                        ),
                      ));
            } catch (error) {
              !viewModel.isStandby
                  ? _controller.forward()
                  : _controller.reverse();

              viewModel.setIsStandby(!viewModel.isStandby);

              viewModel.setIsStandby(false);
              Future.delayed(Duration.zero)
                  .then((value) => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("$error"),
                        ),
                      ));
            }
          },
          child: AnimatedContainer(
            width: 246,
            height: 127,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(160.0),
                gradient: viewModel.isStandby
                    ? const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                            Color(0xFFE74D5F),
                            Color(0xFFFF5C97),
                          ])
                    : const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                            Color(0xFF656363),
                            Color(0xFF989294),
                          ])),
            duration: const Duration(milliseconds: 250),
            child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.translate(
                      offset: Offset(_animation.value, 0),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.all(11),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.25,
                            height: MediaQuery.of(context).size.height,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(160.0),
                                color: const Color(0xFFFFFCFF)),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              child: Icon(
                                Icons.power_settings_new,
                                size: 72,
                                color: viewModel.isStandby
                                    ? const Color(0xFFFF5C97)
                                    : const Color(0xFF989294),
                              ),
                            ),
                          ),
                        ),
                      ));
                }),
          ),
        );
      },
    );
  }
}
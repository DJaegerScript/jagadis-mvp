import 'package:flutter/material.dart';
import 'package:jagadis/sos/view_models/sos_view_models.dart';
import 'package:provider/provider.dart';

class StandbySwitchComponent extends StatefulWidget {
  const StandbySwitchComponent({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _StandbySwitchComponentState();
}

class _StandbySwitchComponentState extends State<StandbySwitchComponent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SOSViewModel>(
      builder: (context, viewModel, child) {
        return GestureDetector(
          onTap: () async {
            String message = await viewModel.handleSwitch();

            Future.delayed(Duration.zero)
                .then((value) => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(message),
                      ),
                    ));
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
                animation: viewModel.animation,
                builder: (context, child) {
                  return Transform.translate(
                      offset: Offset(viewModel.animation.value, 0),
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

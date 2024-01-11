import 'package:flutter/material.dart';

class StandbySwitchComponent extends StatefulWidget {
  const StandbySwitchComponent(
      {super.key, required this.isStandby, required this.setStandby});

  final bool isStandby;
  final Function setStandby;

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
    return GestureDetector(
      onTap: () {
        if (!widget.isStandby) {
          _controller.forward();
        } else {
          _controller.reverse();
        }

        widget.setStandby();
      },
      child: AnimatedContainer(
        width: 246,
        height: 127,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(160.0),
            gradient: widget.isStandby
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
                            color: widget.isStandby
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
  }
}

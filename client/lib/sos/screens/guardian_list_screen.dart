import 'package:jagadis/sos/components/collapse_guardian_button_component.dart';
import 'package:jagadis/sos/components/guardian_list_component.dart';
import 'package:jagadis/sos/components/reset_guardian_component.dart';
import 'package:jagadis/sos/view_models/guardian_view_models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GuardianListScreen extends StatefulWidget {
  const GuardianListScreen({super.key, required this.isHidden});

  final bool isHidden;

  @override
  State<StatefulWidget> createState() => _GuardianListScreenState();
}

class _GuardianListScreenState extends State<GuardianListScreen> {
  double _contactListHeight = 350;
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    double maxHeight = MediaQuery.of(context).size.height;
    return ChangeNotifierProvider(
      create: (context) => GuardianViewModel(),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: AnimatedContainer(
          height: widget.isHidden ? 0 : _contactListHeight,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.75),
            borderRadius:
                BorderRadius.circular(_contactListHeight != maxHeight ? 36 : 0),
          ),
          duration: const Duration(milliseconds: 250),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                CollapseGuardianButtonComponent(collapseContact: () {
                  setState(() {
                    _contactListHeight = 350;
                    _isExpanded = false;
                  });
                }),
                GuardianListComponent(
                  finaliseHeight: () {
                    setState(() {
                      if (_contactListHeight > 400 && !_isExpanded) {
                        _contactListHeight = maxHeight;
                        _isExpanded = true;
                      } else {
                        _contactListHeight = 350;
                        _isExpanded = false;
                      }
                    });
                  },
                  updateHeight: (double positionY) {
                    setState(() {
                      double height = maxHeight - positionY;

                      if (height < 350) {
                        _contactListHeight = 350;
                      } else {
                        _contactListHeight = height;
                      }
                    });
                  },
                ),
                ResetGuardianComponent(
                  isExpanded: _isExpanded,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

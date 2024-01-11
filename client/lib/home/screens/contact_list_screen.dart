import 'package:client/home/components/collapse_contact_button_component.dart';
import 'package:client/home/components/contact_list_component.dart';
import 'package:flutter/material.dart';

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({super.key, required this.isHidden});

  final bool isHidden;

  @override
  State<StatefulWidget> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  double _contactListHeight = 350;
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    double maxHeight = MediaQuery.of(context).size.height;
    return Align(
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
              CollapseContactButtonComponent(collapseContact: () {
                setState(() {
                  _contactListHeight = 350;
                  _isExpanded = false;
                });
              }),
              ContactListComponent(
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
              )
            ],
          ),
        ),
      ),
    );
  }
}

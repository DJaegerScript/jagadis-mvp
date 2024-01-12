import 'package:flutter/material.dart';

class CollapseGuardianButtonComponent extends StatelessWidget {
  const CollapseGuardianButtonComponent(
      {super.key, required this.collapseContact});

  final Function collapseContact;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsetsDirectional.only(start: 16, top: 10),
      decoration:
          const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      width: 44,
      height: 44,
      child: GestureDetector(
        onTap: () {
          collapseContact();
        },
        child: const Icon(
          Icons.arrow_back,
          size: 32,
        ),
      ),
    );
  }
}

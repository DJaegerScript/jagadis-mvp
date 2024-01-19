import 'package:flutter/material.dart';

class AuthMenuComponent extends StatelessWidget {
  const AuthMenuComponent(
      {super.key, required this.label, required this.screen});

  final Widget screen;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topRight,
        child: Container(
          margin: const EdgeInsets.all(20),
          child: TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => screen,
                ));
              },
              child: Text(
                label,
                style: const TextStyle(
                  color: Color(0xFFFF5C96),
                  fontSize: 14,
                ),
              )),
        ));
  }
}

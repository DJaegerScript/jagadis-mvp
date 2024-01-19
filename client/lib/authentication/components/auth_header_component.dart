import 'package:flutter/material.dart';

class AuthHeaderComponent extends StatelessWidget {
  const AuthHeaderComponent({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Align(
          alignment: AlignmentDirectional.topStart,
          child: Image(
              image: AssetImage("assets/images/logo_jagadis.png"),
              width: 200,
              height: 200,
              fit: BoxFit.cover),
        ),
        Align(
          heightFactor: 2,
          alignment: Alignment.bottomLeft,
          child: Padding(
              padding: const EdgeInsetsDirectional.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                      text: const TextSpan(
                          text: "Selamat datang di ",
                          style: TextStyle(
                              color: Color(0xFF170015),
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                          children: [
                        TextSpan(
                          text: "JaGadis",
                          style: TextStyle(
                              color: Color(0xFFFF5C96),
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        )
                      ])),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(text,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ))
                ],
              )),
        )
      ],
    );
  }
}

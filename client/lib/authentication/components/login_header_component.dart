import 'package:flutter/material.dart';

class LoginHeaderComponent extends StatelessWidget {
  const LoginHeaderComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Column(
          children: [
            Align(
              alignment: AlignmentDirectional.topStart,
              child: Image(
                  image: AssetImage("assets/images/logo_jagadis.png"),
                  width: 250,
                  height: 250,
                  fit: BoxFit.cover),
            ),
          ],
        ),
        Column(
          children: [
            const SizedBox(
              height: 170,
            ),
            Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: RichText(
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
                    ]))),
            const SizedBox(
              height: 2,
            ),
            Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: const Text(
                    "Bersiaplah melindungi diri Anda. Atur tombol darurat dan gunakan fitur preventif!",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ))),
          ],
        )
      ],
    );
  }
}

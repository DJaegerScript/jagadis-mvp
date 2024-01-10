import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LogoComponent extends StatelessWidget {
  const LogoComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset("assets/images/jagadis_insignia.svg"),
        const SizedBox(
          width: 14,
        ),
        SvgPicture.asset("assets/images/jagadis_wordmark.svg"),
      ]
    );
  }
  
}
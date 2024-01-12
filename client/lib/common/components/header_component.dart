import 'package:jagadis/common/components/logo_component.dart';
import 'package:flutter/material.dart';

class HeaderComponent extends StatelessWidget {
  const HeaderComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsetsDirectional.symmetric(vertical: 9, horizontal: 19.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const LogoComponent(),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.account_circle,
              ))
        ],
      ),
    );
  }
}

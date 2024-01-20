import 'package:flutter/cupertino.dart';
import 'package:simple_shadow/simple_shadow.dart';

class EmptyListComponent extends StatelessWidget {
  const EmptyListComponent(
      {super.key, required this.text, required this.title});

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
      child: SizedBox(
        width: 259,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SimpleShadow(
                opacity: 0.25,
                offset: const Offset(5, 5),
                sigma: 7,
                child: Image.asset("assets/images/list_empty_state.png"),
              ),
              const SizedBox(
                height: 14,
              ),
              Text(
                title,
                style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: Color(0xFF170015)),
              ),
              Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Color(0xFF79747E)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:client/home/components/contact_card_component.dart';
import 'package:flutter/material.dart';

class ContactListComponent extends StatefulWidget {
  const ContactListComponent(
      {super.key, required this.updateHeight, required this.finaliseHeight});

  final Function(double positionY) updateHeight;
  final Function() finaliseHeight;

  @override
  State<StatefulWidget> createState() => _ContactListComponentState();
}

class _ContactListComponentState extends State<ContactListComponent> {
  @override
  Widget build(BuildContext context) {
    double maxHeight = MediaQuery.of(context).size.height;
    return Align(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        onVerticalDragEnd: (DragEndDetails details) {
          setState(() {
            widget.finaliseHeight();
          });
        },
        onVerticalDragUpdate: (DragUpdateDetails details) {
          setState(() {
            double positionY = details.globalPosition.dy;
            widget.updateHeight(positionY);
          });
        },
        child: Container(
          padding:
              const EdgeInsetsDirectional.only(start: 21, top: 12, end: 21),
          width: MediaQuery.of(context).size.width,
          height: maxHeight - maxHeight * 0.11,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.elliptical(36, 36)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  spreadRadius: 3,
                  blurRadius: 5,
                )
              ]),
          child: Column(
            children: [
              Container(
                width: 38,
                height: 5,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(36)),
                    color: Color(0xFFD9D9D9)),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Daftar Penerima Sinyal SOS",
                      style: TextStyle(
                          color: Color(0xFF170015),
                          fontSize: 16,
                          fontWeight: FontWeight.w700)),
                  InkWell(
                    onTap: () {},
                    child: const Row(
                      children: [
                        Icon(Icons.add, size: 24, color: Color(0xFFFF5C97)),
                        SizedBox(width: 8),
                        // Adjust the spacing between icon and text
                        Text(
                          'Tambah',
                          style: TextStyle(
                              color: Color(0xFFFF5C97),
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              const Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    ContactCardComponent(),
                    ContactCardComponent(),
                    ContactCardComponent(),
                    ContactCardComponent(),
                    ContactCardComponent(),
                    ContactCardComponent(),
                    ContactCardComponent(),
                    ContactCardComponent(),
                    ContactCardComponent(),
                    ContactCardComponent(),
                    ContactCardComponent(),
                    ContactCardComponent()
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}

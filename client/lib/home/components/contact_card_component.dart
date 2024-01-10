import 'package:flutter/material.dart';

// TODO: create parameter
class ContactCardComponent extends StatelessWidget {
  const ContactCardComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
          elevation: 5,
          shadowColor: Colors.black,
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8))),
            width: MediaQuery.of(context).size.width,
            height: 62,
            child: Padding(
                padding: const EdgeInsetsDirectional.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                        ),
                        SizedBox(
                          width: 9,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Nama User",
                              style: TextStyle(
                                  color: Color(0xFF170015),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14),
                            ),
                            Text(
                              "+6285156217864",
                              style: TextStyle(
                                  color: Color(0xFF79747E),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12),
                            )
                          ],
                        )
                      ],
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.remove_circle,
                        color: Color(0xFFE74D5F),
                      ),
                    )
                  ],
                )),
          )),
    );
  }
}

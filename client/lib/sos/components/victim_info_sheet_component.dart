import 'package:flutter/material.dart';
import 'package:jagadis/common/services/utility_service.dart';

class VictimInfoSheetComponent extends StatelessWidget {
  final String name;
  final String phoneNumber;
  final DateTime activatedAt;

  const VictimInfoSheetComponent(
      {super.key,
      required this.name,
      required this.phoneNumber,
      required this.activatedAt});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
          padding: const EdgeInsetsDirectional.symmetric(
              horizontal: 21, vertical: 12),
          width: MediaQuery.of(context).size.width,
          constraints:
              const BoxConstraints.tightForFinite(height: double.infinity),
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
            mainAxisSize: MainAxisSize.min,
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
                children: [
                  CircleAvatar(
                    backgroundColor: UtilityService.generateRandomColor(),
                    radius: 45,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: const TextStyle(
                              color: Color(0xFF170015),
                              fontWeight: FontWeight.w600,
                              fontSize: 20)),
                      Text(UtilityService.formatPhoneNumber(phoneNumber),
                          style: const TextStyle(
                              color: Color(0xFF79747E), fontSize: 16)),
                      Text(UtilityService.formatDate(activatedAt),
                          style: const TextStyle(
                              color: Color(0xFF79747E), fontSize: 16)),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFFF5C97),
                    ),
                    onPressed: () {},
                    child: const Padding(
                      padding: EdgeInsetsDirectional.all(6),
                      child: Text(
                        "Hubungi Polisi",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 16),
                      ),
                    )),
              )
            ],
          )),
    );
  }
}

import 'package:jagadis/common/services/utility_service.dart';
import 'package:flutter/material.dart';

class CardBodyComponent extends StatefulWidget {
  const CardBodyComponent(
      {super.key, required this.action, this.name, required this.info});

  final Widget action;
  final String? name;
  final String info;

  @override
  State<StatefulWidget> createState() => _CardBodyComponentState();
}

class _CardBodyComponentState extends State<CardBodyComponent> {
  late Color _avatarColor;

  @override
  void initState() {
    super.initState();

    _avatarColor = UtilityService.generateRandomColor();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> cardDetails = [
      Text(
        widget.info,
        style: const TextStyle(
            color: Color(0xFF79747E),
            fontWeight: FontWeight.w400,
            fontSize: 12),
      )
    ];

    if (widget.name != null) {
      cardDetails.insert(
        0,
        Text(
          style: const TextStyle(
              color: Color(0xFF170015),
              fontWeight: FontWeight.w500,
              fontSize: 14),
          widget.name!,
        ),
      );
    }

    return Card(
        elevation: 5,
        shadowColor: Colors.black,
        child: Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8))),
          width: MediaQuery.of(context).size.width,
          height: 72,
          child: Padding(
              padding: const EdgeInsetsDirectional.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: _avatarColor,
                        child: Text(
                            UtilityService.getInitial(widget.name ?? ""),
                            style:
                                const TextStyle(fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(
                        width: 9,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: cardDetails,
                      )
                    ],
                  ),
                  widget.action
                ],
              )),
        ));
  }
}

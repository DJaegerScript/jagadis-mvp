import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jagadis/common/services/websocket_service.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen(
      {super.key, required this.alertId, required this.userId});

  final String alertId;
  final String userId;

  @override
  State<StatefulWidget> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  late WebsocketService websocket;
  final StreamController<String> _streamController = StreamController<String>();

  late GoogleMapController mapController;

  @override
  void initState() {
    super.initState();

    websocket = WebsocketService(widget.alertId, widget.userId);

    websocket.getChannel().stream.listen((event) {
      print(event);
    });
  }

  @override
  void dispose() {
    websocket.closeConnection();
    _streamController.close();
    super.dispose();
  }

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(weight: 700),
        title: const Text('Location',
            style: TextStyle(
              color: Color(0xFF170015),
              fontWeight: FontWeight.w700,
            )),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 75.0,
            ),
          ),
          // VictimInfoSheetComponent(
          //     name: name, phoneNumber: phoneNumber, activatedAt: activatedAt)
        ],
      ),
    );
  }
}

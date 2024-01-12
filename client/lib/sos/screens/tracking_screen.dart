import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jagadis/common/services/utility_service.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<StatefulWidget> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  late GoogleMapController mapController;

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
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 21, vertical: 12),
                width: MediaQuery.of(context).size.width,
                constraints: const BoxConstraints.tightForFinite(
                    height: double.infinity),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.elliptical(36, 36)),
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
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("User Name",
                                style: TextStyle(
                                    color: Color(0xFF170015),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20)),
                            Text("+62 XXX - XXXX - 1234",
                                style: TextStyle(
                                    color: Color(0xFF79747E), fontSize: 16)),
                            Text("12 Januari 2024 13.00",
                                style: TextStyle(
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
          )
        ],
      ),
    );
  }
}

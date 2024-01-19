import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jagadis/sos/components/victim_info_sheet_component.dart';
import 'package:jagadis/sos/models/track_alert_response.dart';
import 'package:jagadis/sos/view_models/sos_view_model.dart';
import 'package:provider/provider.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen(
      {super.key, required this.alertId, required this.userId});

  final String alertId;
  final String userId;

  @override
  State<StatefulWidget> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  late GoogleMapController mapController;

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
      body: ChangeNotifierProvider(
        create: (context) => SOSViewModel(false, null),
        child: Consumer<SOSViewModel>(
          builder: (context, viewModel, child) {
            return FutureBuilder(
                future: viewModel.trackAlert(widget.userId, widget.alertId),
                builder: (BuildContext context,
                    AsyncSnapshot<TrackAlertResponse> snapshot) {
                  if (snapshot.data == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    TrackAlertResponse data = snapshot.data!;

                    return Stack(
                      children: [
                        GoogleMap(
                          onMapCreated: _onMapCreated,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(data.location.latitude,
                                data.location.longitude),
                            zoom: 45.0,
                          ),
                          markers: {
                            Marker(
                              markerId: MarkerId(data.user.userId),
                              position: LatLng(data.location.latitude,
                                  data.location.longitude),
                            )
                          },
                        ),
                        VictimInfoSheetComponent(
                            name: data.user.name,
                            phoneNumber: data.user.phoneNumber,
                            activatedAt: data.user.activatedAt)
                      ],
                    );
                  }
                });
          },
        ),
      ),
    );
  }
}

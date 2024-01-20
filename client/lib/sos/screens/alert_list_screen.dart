import 'package:flutter/material.dart';
import 'package:jagadis/common/components/empty_list_component.dart';
import 'package:jagadis/sos/components/alert_card_component.dart';
import 'package:jagadis/sos/models/get_all_activated_alert_response.dart';
import 'package:jagadis/sos/view_models/sos_view_model.dart';
import 'package:provider/provider.dart';

class AlertListScreen extends StatelessWidget {
  const AlertListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (content) => SOSViewModel(false, null),
      child: Consumer<SOSViewModel>(builder: (context, viewModel, child) {
        return FutureBuilder(
          future: viewModel.getAllActivatedAlert(),
          builder: (BuildContext context,
              AsyncSnapshot<GetAllActivatedAlertResponse> snapshot) {
            if (snapshot.data != null) {
              List<Alert>? alerts = snapshot.data?.alerts;

              if (alerts != null && alerts.isNotEmpty) {
                return Expanded(
                    child: Padding(
                  padding: const EdgeInsetsDirectional.all(16),
                  child: ListView.builder(
                    itemCount: alerts.length,
                    itemBuilder: (context, index) => Column(children: [
                      AlertCardComponent(
                        id: alerts[index].id,
                        userId: alerts[index].userId,
                        phoneNumber: alerts[index].phoneNumber,
                        name: alerts[index].name,
                        activatedAt: alerts[index].activatedAt,
                      )
                    ]),
                  ),
                ));
              }

              return const EmptyListComponent(
                  title: "Tidak ada pesan SOS",
                  text:
                      "Tidak ada pesan SOS diterima. Semoga orang terdekat anda dalam keadaan baik-baik saja");
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        );
      }),
    );
  }
}

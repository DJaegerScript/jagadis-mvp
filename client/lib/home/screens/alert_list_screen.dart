import 'package:client/home/components/alert_card_component.dart';
import 'package:client/home/models/get_all_activated_alert_response.dart';
import 'package:client/home/view_models/sos_view_models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_shadow/simple_shadow.dart';

class AlertListScreen extends StatelessWidget {
  const AlertListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (content) => SOSViewModel(),
      child: Consumer<SOSViewModel>(builder: (context, viewModel, child) {
        return FutureBuilder(
          future: viewModel.getAllActivatedAlert(),
          builder: (BuildContext context,
              AsyncSnapshot<GetAllActivatedAlertResponse> snapshot) {
            if (snapshot.hasData) {
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
                        phoneNumber: alerts[index].phoneNumber,
                        name: alerts[index].name,
                        activatedAt: alerts[index].activatedAt,
                      )
                    ]),
                  ),
                ));
              }

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
                          child:
                              Image.asset("assets/images/list_empty_state.png"),
                        ),
                        const SizedBox(
                          height: 14,
                        ),
                        const Text(
                          "Tidak ada pesan SOS",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              color: Color(0xFF170015)),
                        ),
                        const Text(
                          "Tidak ada pesan SOS diterima. Semoga orang terdekat anda dalam keadaan baik-baik saja",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Color(0xFF79747E)),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return const Expanded(
                  child: Center(child: CircularProgressIndicator()));
            }
          },
        );
      }),
    );
  }
}

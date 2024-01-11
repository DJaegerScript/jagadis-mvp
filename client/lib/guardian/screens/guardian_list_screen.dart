import 'package:client/common/models/common_response.dart';
import 'package:client/guardian/components/guardian_contact_field.dart';
import 'package:client/guardian/models/get_all_guardian_response.dart';
import 'package:client/home/services/guardian_service.dart';
import 'package:flutter/material.dart';

class GuardianListScreen extends StatelessWidget {
  const GuardianListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: FutureBuilder(
        future: GuardianService.getAllGuardians(context),
        builder: (BuildContext context,
            AsyncSnapshot<CommonResponse<GetAllGuardianResponse>> snapshot) {
          if (snapshot.hasData) {
            List<Guardian>? guardians = snapshot.data?.content?.guardians;

            return ListView.builder(
              itemCount: guardians!.isEmpty ? 1 : guardians.length,
              itemBuilder: (context, index) => Column(children: [
                GuardianContactComponent(
                  guardian: guardians.isEmpty ? null : guardians[index],
                )
              ]),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      )),
    );
  }
}

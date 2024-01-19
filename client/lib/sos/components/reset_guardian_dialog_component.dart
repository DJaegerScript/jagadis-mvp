import 'package:flutter/material.dart';
import 'package:jagadis/common/models/common_response.dart';
import 'package:jagadis/sos/view_models/guardian_view_model.dart';
import 'package:provider/provider.dart';

class ResetGuardianDialogComponent extends StatefulWidget {
  const ResetGuardianDialogComponent({
    super.key,
    required this.action,
  });

  final Function action;

  @override
  State<StatefulWidget> createState() => _ResetGuardianDialogComponent();
}

class _ResetGuardianDialogComponent
    extends State<ResetGuardianDialogComponent> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GuardianViewModel(),
      child: Consumer<GuardianViewModel>(
        builder: (context, viewModel, child) {
          return AlertDialog(
            title: const Text("Hapus Semua Penerima Sinyal SOS",
                style: TextStyle(color: Color(0xFF170015), fontSize: 16)),
            content: viewModel.isLoading
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(),
                      )
                    ],
                  )
                : const Text(
                    "Apakah kamu yakin akan menghapus semua penerima sinyal SOS?"),
            actions: viewModel.isLoading
                ? []
                : [
                    TextButton(
                        onPressed: () async {
                          viewModel.setLoading(true);

                          CommonResponse response =
                              await viewModel.resetGuardian();

                          Future.delayed(Duration.zero).then((value) => {
                                Navigator.of(context).pop(),
                              });

                          if (response.isSuccess) {
                            widget.action();
                            Future.delayed(Duration.zero).then((value) =>
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Penerima sinyal berhasil dihapus!'),
                                  ),
                                ));
                          } else {
                            Future.delayed(Duration.zero).then((value) =>
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(response.message),
                                  ),
                                ));
                          }
                          viewModel.setLoading(false);
                        },
                        child: const Text(
                          "Hapus",
                          style: TextStyle(color: Color(0xFFE74D5F)),
                        )),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFFFF5C97)),
                      child: const Text("Batalkan",
                          style: TextStyle(color: Colors.white)),
                    )
                  ],
          );
        },
      ),
    );
  }
}

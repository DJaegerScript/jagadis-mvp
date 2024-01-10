import 'package:client/common/components/header_component.dart';
import 'package:client/home/screens/contact_list_screen.dart';
import 'package:client/home/screens/sos_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
          length: 2,
          child: Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  title: const HeaderComponent(),
                  bottom: const TabBar(
                    unselectedLabelColor: Color(0xFF49454f),
                    labelColor: Color(0xFFff5c97),
                    indicatorColor: Color(0xFFff5c97),
                    tabs: [Tab(text: "SOS"), Tab(text: "Tracking")],
                  ),
                ),
                body: const TabBarView(children: [
                  SOSScreen(),
                  Center(child: Text("Tracking")),
                ]),
              ),
              const ContactListScreen()
            ],
          )),
    );
  }
}

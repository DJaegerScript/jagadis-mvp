import 'package:client/common/components/header_component.dart';
import 'package:client/sos/screens/alert_list_screen.dart';
import 'package:client/sos/screens/guardian_list_screen.dart';
import 'package:client/sos/screens/sos_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isContactListHidden = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2)
      ..addListener(() {
        setState(() {
          _isContactListHidden = _tabController.index != 0;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: const HeaderComponent(),
              bottom: TabBar(
                controller: _tabController,
                unselectedLabelColor: const Color(0xFF49454f),
                labelColor: const Color(0xFFff5c97),
                indicatorColor: const Color(0xFFff5c97),
                tabs: const [Tab(text: "SOS"), Tab(text: "Tracking")],
              ),
            ),
            body: TabBarView(controller: _tabController, children: const [
              SOSScreen(),
              AlertListScreen(),
            ]),
          ),
          GuardianListScreen(
            isHidden: _isContactListHidden,
          )
        ],
      ),
    );
  }
}

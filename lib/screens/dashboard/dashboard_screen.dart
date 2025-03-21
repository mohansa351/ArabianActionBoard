
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/notifications_controller.dart';
import '../../utils/common_widgets.dart';
import '../../utils/constants.dart';
import '../home/home.dart';
import '../settings/settings.dart';
import '../task/task.dart';
import 'task_filter_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  List<Widget> screens = [
    const HomeScreen(),
    const TaskScreen(),
    // const ActivityScreen(),
    const SettingScreen(),
  ];

   @override
  void initState() {
    super.initState();
    Future.microtask(()=> Get.find<NotificationsController>().startNotificationCheckStreaming());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(),
      body: screens[_currentIndex],
      floatingActionButton: _currentIndex == 1
          ? GestureDetector(
              onTap: () {
                Get.to(()=> const TaskFilterScreen());
              },
              child: CircleAvatar(
                radius: 30,
                backgroundColor: primaryColor,
                child: Image.asset(filterIcon, height: 30),
              ),
            )
          : const SizedBox(),
      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle:
            const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        unselectedLabelStyle:
            const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Image.asset(_currentIndex == 0 ? homeActive : home,
                  height: 20),
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Image.asset(_currentIndex == 1 ? taskActive : task,
                  height: 20),
            ),
            label: 'Task',
          ),
          // BottomNavigationBarItem(
          //   icon: Padding(
          //     padding: const EdgeInsets.only(bottom: 5),
          //     child: Image.asset(_currentIndex == 2 ? activityActive : activity,
          //         height: 20),
          //   ),
          //   label: 'Activity',
          // ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Image.asset(_currentIndex == 3 ? settingsActive : settings,
                  height: 20),
            ),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

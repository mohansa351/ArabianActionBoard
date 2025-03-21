import 'package:bizlogika_app/screens/notifications/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/common_widgets.dart';
import '../../utils/constants.dart';
import 'user_info_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String token = "";
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: ListView(
        children: [
          const Text('Settings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
          const SizedBox(height: 20),
          GetBuilder<AuthController>(
            builder: (AuthController controller) {
              return ListTile(
                contentPadding: const EdgeInsets.all(0),
                leading: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: lightPurpleColor,
                    ),
                    child: Center(
                      child: Text(
                        controller.userData!.userName[0].toUpperCase(),
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                            color: Colors.purple.shade800),
                      ),
                    )),
                title: Text(
                    controller.userData != null
                        ? controller.userData!.userName
                        : "",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600)),
                subtitle: Text(
                    controller.userData != null
                        ? controller.userData!.email
                        : "",
                    style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500)),
              );
            },
          ),
          const SizedBox(height: 30),
          CustomListTile(
              avatarImage: person,
              title: 'Account',
              subtitle: 'Stores personal information & preferences',
              onTap: () {
                Get.to(() => const UserInfoScreen());
              }),
          const SizedBox(height: 30),
          CustomListTile(
            avatarImage: belicon,
            title: 'Notification',
            subtitle: 'You can access to notification data & actions',
            onTap: () {
              Get.to(()=> const NotificationScreen());
            },
          ),
          const SizedBox(height: 30),
          // Text(token),
          GestureDetector(
            onTap: () async {
              //  token = await credentialController.getOAuthToken();
              //  print(token);
              //  setState(() {

              //  });
              logoutDialog(context);
            },
            child: Center(
              child: Container(
                height: 40,
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0XFFF04438), width: 2),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Center(
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0XFFF04438),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

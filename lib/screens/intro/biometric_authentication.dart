import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/common_widgets.dart';
import '../../utils/constants.dart';

class BiometricAuthentication extends StatefulWidget {
  const BiometricAuthentication({super.key});

  @override
  State<BiometricAuthentication> createState() =>
      _BiometricAuthenticationState();
}

class _BiometricAuthenticationState extends State<BiometricAuthentication> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => Get.find<AuthController>().deviceAuth());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: GetBuilder<AuthController>(
      builder: (AuthController controller) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 50),
              Center(
                child: SizedBox(width: 200, child: Image.asset(logo)),
              ),
              const SizedBox(height: 35),
              Icon(Icons.lock, color: primaryColor, size: 40),
              const SizedBox(height: 20),
              const Text('Authentication required',
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF000000),
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 45),
              CustomButton(title: "Authenticate", onTap: (){
                controller.deviceAuth();
              })
            ],
          ),
        );
      },
    ),
    );
  }
}

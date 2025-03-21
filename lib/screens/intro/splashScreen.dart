
import 'package:bizlogika_app/controllers/credential_controller.dart';
import 'package:flutter/material.dart';
import '../../utils/constants.dart';


class SplashScrren extends StatefulWidget {
  const SplashScrren({super.key});

  @override
  State<SplashScrren> createState() => _SplashScrrenState();
}

class _SplashScrrenState extends State<SplashScrren> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3)).then((value) => credentialController.getUserId(false),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Center(child: Image.asset(logo)),
      ),
    );
  }
}


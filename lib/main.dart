import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/auth_controller.dart';
import 'controllers/notifications_controller.dart';
import 'controllers/task_controller.dart';
import 'firebase/firebase_options.dart';
import 'screens/intro/splashScreen.dart';

Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'BizLogika App',
      initialBinding: BindingsBuilder(() {
        Get.put(AuthController());
        Get.put(TaskController());
        Get.put(NotificationsController());
      }),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.light(),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0XFFF5F5F4),
        appBarTheme: const AppBarTheme(
          color: Color(0XFFF5F5F4),
        ),
      ),
      home: const SplashScrren(),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

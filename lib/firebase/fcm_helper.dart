// // ignore_for_file: use_build_context_synchronously

// import 'dart:io';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class FCM {
//   RemoteMessage? _messages;
//   BuildContext? context;
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   void onDidReceiveLocalNotification(
//       int? id, String? title, String? body, String? payload) async {
//     debugPrint('Notification Local>>>>>: $payload');
//     handleClick(_messages!);
//   }

//   void onDidReceiveNotificationResponse(
//       NotificationResponse notificationResponse) async {
//     final String? payload = notificationResponse.payload;
//     if (payload != null) {
//       debugPrint(
//           'When screen is on this work notification payload>>>>>: $payload');
//       // Parse the payload or use the global _messages directly if necessary
//       handleClick(_messages!);
//     }
//   }

// // Modify the _showLocalNotification method to include the message as a payload
//   Future<void> _showLocalNotification(
//       String? title, String? body, RemoteMessage message) async {
//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );

//     var android = const AndroidInitializationSettings('@mipmap/ic_launcher');
//     var initializationSettingsDarwin = const DarwinInitializationSettings();

//     flutterLocalNotificationsPlugin.initialize(
//         InitializationSettings(
//             android: android, iOS: initializationSettingsDarwin),
//         onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);

//     var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
//       "field_marketing",
//       "field_marketing",
//       importance: Importance.max,
//       playSound: true,
//       showProgress: true,
//       priority: Priority.high,
//       ticker: 'Test ticker',
//     );

//     var platformChannelSpecifics = NotificationDetails(
//       android: androidPlatformChannelSpecifics,
//       iOS: const DarwinNotificationDetails(categoryIdentifier: "plainCategory"),
//     );

//     await flutterLocalNotificationsPlugin.show(
//       0,
//       title,
//       body,
//       platformChannelSpecifics,
//       payload: message.data.toString(), // Pass message data as payload
//     );
//   }

// // Update the setNotifications method to pass the message to _showLocalNotification
//   setNotifications(BuildContext context) {
//     if (Platform.isAndroid) {
//       flutterLocalNotificationsPlugin
//           .resolvePlatformSpecificImplementation<
//               AndroidFlutterLocalNotificationsPlugin>()!
//           .requestNotificationsPermission();
//     } else if (Platform.isIOS) {
//       flutterLocalNotificationsPlugin
//           .resolvePlatformSpecificImplementation<
//               IOSFlutterLocalNotificationsPlugin>()!
//           .requestPermissions();
//     }

//     FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);

//     FirebaseMessaging.onMessageOpenedApp.listen((message) {
//       // handleClick(context, message);
//     });

//     FirebaseMessaging.instance.getInitialMessage().then((message) {
//       if (message != null) {
//         handleClick(message);
//       }
//     });

//     FirebaseMessaging.onMessage.listen((message) async {
//       _messages = message;
//       context = context;
//       _showLocalNotification(
//           message.notification!.title, message.notification!.body, message);
//     });
//   }

//   handleClick(RemoteMessage message) async {}
// }

// // background message
// Future<void> onBackgroundMessage(RemoteMessage message) async {}

import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bizlogika_app/controllers/credential_controller.dart';
import 'package:bizlogika_app/screens/dashboard/dashboard_screen.dart';
import 'package:bizlogika_app/screens/task/task_detail_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


// Global function for notification action handling
Future<void> onNotificationAction(ReceivedAction action) async {
  debugPrint('Notification action received: ${action.payload}');
  if (action.payload != null) {
    debugPrint('Payload data: ${action.payload}');
    // Add your navigation or data handling logic here
  }
}

class FCM {
  RemoteMessage? _messages;

  FCM() {
    _initializeAwesomeNotifications();
  }

  void _initializeAwesomeNotifications() {
    AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'bizlogika',
          channelName: 'Bizlogika Notifications',
          channelDescription: 'Notification channel for Bizlogika',
          defaultColor: const Color(0xFF9D50DD),
          importance: NotificationImportance.High,
          channelShowBadge: true,
        ),
      ],
      debug: true,
    );

    // Set global listener for notification actions
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: onNotificationAction,
    );

    _requestNotificationPermissions();
  }

  Future<void> _requestNotificationPermissions() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();

    if (!isAllowed) {
      // Request permission to send notifications
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  Future<void> _showLocalNotification(
      String? title, String? body, RemoteMessage message) async {
    if (Platform.isAndroid) {
      AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
        if (!isAllowed) {
          AwesomeNotifications().requestPermissionToSendNotifications();
        }
      });
    }

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 0,
        channelKey: 'bizlogika',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
        // icon: 'resource://assets/icons/notification_icon.png',
        // payload: message.data,
      ),
    );
  }

  setNotifications(BuildContext context) {
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      handleClick(message);
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        handleClick(message);
      }
    });

    FirebaseMessaging.onMessage.listen((message) async {
      _messages = message;
      _showLocalNotification(
          message.notification?.title, message.notification?.body, message);
    });
  }

  void handleClick(RemoteMessage message) async {
    debugPrint('Notification clicked with data: ${message.data}');
    String taskId = message.data['task_id'] ?? '';
    String docType = message.data['doc_type'] ?? '';
    if (taskId != "" && docType != "") {
      // Perform the necessary action with taskId, for example, navigate to a specific screen
      print('Task ID: $taskId >>>>>>>>>>>>>.');
      await credentialController.getUserId(true);
      Get.to(() => TaskDetailScreen(
          taskId: taskId, notification: true, docType: docType));
    } else {
      await credentialController.getUserId(true);
      Get.to(() => const DashboardScreen());
    }
  }
}

// Background message handler
Future<void> onBackgroundMessage(RemoteMessage message) async {
  debugPrint('Background message received: ${message.messageId}');
}

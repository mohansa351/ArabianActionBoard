import 'dart:async';
import 'dart:convert';
import 'package:bizlogika_app/utils/common_widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/notification_model.dart';
import '../utils/constants.dart';
import 'auth_controller.dart';
import 'credential_controller.dart';

// final NotificationsController notificationsController =
//     NotificationsController();

class NotificationsController extends GetxController {
  List<NotificationModel> notificationReadList = [];
  List<NotificationModel> notificationUnreadList = [];
  List<String> unreadNotificationIds = [];
  String unreadNotifcationCount = "";
////
////
//// Firebase notifications
  Future<void> firebaseNotification(authToken, String fcmToken, String title,
      String body, String taskId, String docType) async {
    try {
      var headers = {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json'
      };
      var request = http.Request(
          'POST',
          Uri.parse(
              'https://fcm.googleapis.com/v1/projects/bizlogika-app/messages:send'));
      request.body = json.encode({
        "message": {
          "token": fcmToken.toString(),
          "notification": {
            "body": body,
            "title": title,
          },
          "data": {"type": 'user', "task_id": taskId, "doc_type": docType}
        }
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      print(response.statusCode);
      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
      } else {
        print(response.reasonPhrase);
        print(await response.stream.bytesToString());
      }
    } catch (e) {
      print(e.toString());
    }
  }

////
////
  int currentNotificationPage = 1;
  bool notificationLoader = false;
  bool loadMore = false;

  updateNotificationsLoader(bool val, bool more) {
    if (val) {
      if (more) {
        loadMore = val;
        update();
      } else {
        notificationLoader = val;
        update();
      }
    } else {
      notificationLoader = val;
      loadMore = val;
      update();
    }
  }

  updateCurrentNotificationPage() {
    currentNotificationPage = 1;
    update();
  }

  Future<void> fetchReadNotifications(bool loadMore) async {
    updateNotificationsLoader(true, loadMore);

    if (!loadMore) {
      updateCurrentNotificationPage();
      notificationReadList.clear();
    }

    try {
      var headers = {
        'Content-Type': 'application/json',
        'Cookie': credentialController.userCookie
      };
      var request = http.Request('POST', Uri.parse(getAllNotificationsUrl));

      request.body = json.encode({
        "filter": {
          "status": "read" //read, unread
        },
        "page": currentNotificationPage,
        "limit": 100
      });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final res = await response.stream.bytesToString();
        var responseData = json.decode(res);

        print(responseData);

        if (responseData["success"] == true) {
          if (responseData["data"] != null) {
            List<dynamic> data = responseData["data"]["notifications"] ?? [];

            if (data.isNotEmpty) {
              for (var notification in data) {
                notificationReadList.add(
                  NotificationModel(
                    title: notification["title"] ?? "",
                    description: notification["description"] ?? "",
                    status: notification["status"] ?? "",
                    taskId: notification["taskId"] ?? "",
                    senderName: notification["senderName"] ?? "",
                    receiverId: notification["receiverId"] ?? "",
                    senderId: notification["senderId"] ?? "",
                    notificationDate: formatDate(notification["created"] ?? ""),
                    docType: notification["documentType"] ?? "",
                  ),
                );
              }
              currentNotificationPage++;
              print(notificationReadList.length);
              print(currentNotificationPage);
              update();
            }
          }
        }
      } else {
        final res = await response.stream.bytesToString();
        var responseData = json.decode(res);

        if (responseData["message"] == "session expired") {
          credentialController.logoutUser();
          showToast("Session expired");
        }
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e.toString());
    } finally {
      updateNotificationsLoader(false, false);
    }
  }

////
////
////

  Future<void> fetchUnreadNotifications(bool loadMore) async {
    updateNotificationsLoader(true, loadMore);

    if (!loadMore) {
      updateCurrentNotificationPage();
      notificationUnreadList.clear();
    }

    try {
      var headers = {
        'Content-Type': 'application/json',
        'Cookie': credentialController.userCookie
      };
      var request = http.Request('POST', Uri.parse(getAllNotificationsUrl));

      request.body = json.encode({
        "filter": {
          "status": "unread" //read, unread
        },
        "page": currentNotificationPage,
        "limit": 100
      });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final res = await response.stream.bytesToString();
        var responseData = json.decode(res);

        print(responseData);

        if (responseData["success"] == true) {
          if (responseData["data"] != null) {
            List<dynamic> data = responseData["data"]["notifications"] ?? [];

            if (data.isNotEmpty) {
              for (var notification in data) {
                notificationUnreadList.add(
                  NotificationModel(
                    title: notification["title"] ?? "",
                    description: notification["description"] ?? "",
                    status: notification["status"] ?? "",
                    senderId: notification["senderId"] ?? "",
                    senderName: notification["senderName"] ?? "",
                    receiverId: notification["receiverId"] ?? "",
                    taskId: notification["taskId"] ?? "",
                    notificationDate: formatDate(notification["created"] ?? ""),
                    docType: notification["documentType"] ?? "",
                  ),
                );
                currentNotificationPage++;
                unreadNotificationIds.add(notification["_id"] ?? "");
              }
              update();
            }
          }
        }
      } else {
        final res = await response.stream.bytesToString();
        var responseData = json.decode(res);

        if (responseData["message"] == "session expired") {
          credentialController.logoutUser();
          showToast("Session expired");
        }
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e.toString());
    } finally {
      updateNotificationsLoader(false, false);
    }
  }

////
////
//// Send notification to user

  Future<String?> findTokenForUser(String receiverId) async {
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Cookie': credentialController.userCookie
      };
      var request = http.Request('GET', Uri.parse('$userInfoUrl$receiverId'));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final res = await response.stream.bytesToString();
        var responseData = json.decode(res);

        if (responseData["success"] == true) {
          var data = responseData["data"]["user"];
          return data["fcmToken"].toString();
        }
      }
    } catch (e) {
      print(e.toString);
    }
  }

  Future<void> sendNotification(NotificationModel notification) async {
    String userName = Get.find<AuthController>().userData!.firstName;

    try {
      String? fcmToken = await findTokenForUser(notification.receiverId);

      var headers = {
        'Content-Type': 'application/json',
        'Cookie': credentialController.userCookie
      };
      var request = http.Request('POST', Uri.parse(sendNotificationsUrl));
      request.body = json.encode({
        "title": notification.title,
        "description": notification.description,
        "status": "unread",
        "senderId": credentialController.userId,
        "senderName": userName,
        "receiverId": notification.receiverId,
        "taskId": notification.taskId,
        "documentType": notification.docType
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 201) {
        if (fcmToken != null &&
            fcmToken.isNotEmpty &&
            fcmToken != "" &&
            fcmToken != "null") {
          firebaseNotification(
              credentialController.getOAuthToken(),
              fcmToken,
              notification.title,
              notification.description,
              notification.taskId,
              notification.docType);
        }
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e.toString());
    }
  }

////
////
//// Update notification status for user
  Future<void> updateNotificationStatus() async {
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Cookie': credentialController.userCookie
      };

      var request = http.Request('PATCH', Uri.parse(sendNotificationsUrl));

      request.body =
          json.encode({"ids": unreadNotificationIds, "status": "read"});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        unreadNotificationIds.clear();
        unreadNotifcationCount = "";
        print(await response.stream.bytesToString());
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e.toString());
    }
  }

////
////
//// Streaming Function

  void startNotificationCheckStreaming() {
    Timer.periodic(const Duration(seconds: 30), (timer) {
      if (credentialController.userId != "" &&
          credentialController.userId != "null") {
        fetchUnreadNotificationCount();
      } 
    });
  }

  Future<void> fetchUnreadNotificationCount() async {
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Cookie': credentialController.userCookie
      };
      var request = http.Request('POST', Uri.parse(getAllNotificationsUrl));

      request.body = json.encode({
        "filter": {
          "status": "unread" //read, unread
        },
        "page": 1,
        "limit": 100
      });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final res = await response.stream.bytesToString();
        var responseData = json.decode(res);

        if (responseData["success"] == true) {
          if (responseData["data"] != null) {
            List<dynamic> data = responseData["data"]["notifications"] ?? [];

            if (data.isNotEmpty) {
              unreadNotifcationCount =
                  data.length.isGreaterThan(5) ? "+5" : "${data.length}";
            }
          }
        }
      } else {
        final res = await response.stream.bytesToString();
        var responseData = json.decode(res);

        if (responseData["message"] == "session expired") {
          credentialController.logoutUser();
          showToast("Session expired");
        }
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e.toString());
    } finally {
      updateNotificationsLoader(false, false);
    }
  }

  // Future<void> checkPendingTasks() async {
  //   try {
  //     var headers = {
  //       'Content-Type': 'application/json',
  //       'Cookie': credentialController.userCookie
  //     };
  //     var request = http.Request('POST', Uri.parse(getTasksUrl));
  //     request.body = json.encode({
  //       "pagination": {"page": 1, "limit": 100},
  //       "filter":
  //           "PENDING", //REJECTED, COMPLETED, ALL, PENDING, APPROVED , ""
  //       "search": "",
  //       "fromDate": "",
  //       "toDate": "",
  //     });
  //     request.headers.addAll(headers);

  //     http.StreamedResponse response = await request.send();

  //     if (response.statusCode == 200) {
  //       final res = await response.stream.bytesToString();
  //       var responseData = json.decode(res);

  //       print(responseData);

  //       if (responseData["success"] == true) {
  //         List<dynamic> tasks = responseData["data"]["tasks"] ?? [];
  //         if (tasks.isNotEmpty) {
  //           ///
  //           /// Send notification if pending tasks available
  //           String fcmToken = await Get.find<AuthController>()
  //                   .getTokenByUserId(credentialController.userId) ??
  //               "";

  //           String name = Get.find<AuthController>().userData!.userName;

  //           var headers = {
  //             'Content-Type': 'application/json',
  //             'Cookie': credentialController.userCookie
  //           };
  //           var request = http.Request('POST', Uri.parse(sendNotificationsUrl));
  //           request.body = json.encode({
  //             "title": "Pending Task!",
  //             "description": "You have pending task. Kindly take the action.",
  //             "status": "unread",
  //             "senderId": credentialController.userId,
  //             "senderName": name,
  //             "receiverId": credentialController.userId,
  //             // "taskId": "",
  //             "documentType": ""
  //           });
  //           request.headers.addAll(headers);

  //           http.StreamedResponse responseNotification = await request.send();

  //           //  firebaseNotification(
  //           //       await credentialController.getOAuthToken(),
  //           //       fcmToken,
  //           //       "Pending Task!",
  //           //       "You have pending task. Kindly take the action.",
  //           //       "",
  //           //       "",
  //           //     );
  //           //     fetchUnreadNotifications(false, true);

  //           if (responseNotification.statusCode == 201) {
  //             if (fcmToken != "") {
  //               firebaseNotification(
  //                 await credentialController.getOAuthToken(),
  //                 fcmToken,
  //                 "Pending Task!",
  //                 "You have pending task. Kindly take the action.",
  //                 "",
  //                 "",
  //               );
  //               fetchUnreadNotifications(false, true);
  //             }
  //           } else {
  //             print(responseNotification.reasonPhrase);
  //           }
  //         }
  //       } else {
  //         print(responseData["errors"].toString());
  //       }
  //     } else {
  //       print(response.reasonPhrase);
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }
}

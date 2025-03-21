import 'package:bizlogika_app/controllers/notifications_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/constants.dart';
import 'notifcations_widget.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final ScrollController _scrollController = ScrollController();
  bool readAll = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Get.find<NotificationsController>().fetchReadNotifications(false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios),
          ),
          title: const Text(
            "Notification",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        body: GetBuilder<NotificationsController>(
          builder: (NotificationsController controller) {
            return NotificationListener(
              onNotification: (notification) {
                if (notification is ScrollEndNotification) {
                  if (_scrollController.position.pixels ==
                      _scrollController.position.maxScrollExtent) {
                    if (readAll) {
                      controller.fetchReadNotifications(true);
                    } else {
                      controller.fetchUnreadNotifications(true).then((val) {
                        controller.updateNotificationStatus();
                      });
                    }
                  }
                }
                return false;
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      const SizedBox(height: 25),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              readAll = true;
                              setState(() {});
                              Future.microtask(() =>
                                  controller.fetchReadNotifications(false));
                            },
                            child: Container(
                              height: 40,
                              color: readAll ? primaryColor : Colors.white,
                              width: screenWidth(context) / 2 - 25,
                              child: Center(
                                child: Text(
                                  "Read",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: readAll
                                          ? Colors.white
                                          : Colors.black54),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              readAll = false;
                              setState(() {});
                              Future.microtask(
                                () => controller
                                    .fetchUnreadNotifications(false)
                                    .then(
                                  (val) {
                                    controller.updateNotificationStatus();
                                  },
                                ),
                              );
                            },
                            child: Container(
                                height: 40,
                                color: !readAll ? primaryColor : Colors.white,
                                width: screenWidth(context) / 2 - 25,
                                child: Center(
                                  child: Text(
                                    "Unread",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: !readAll
                                            ? Colors.white
                                            : Colors.black54),
                                  ),
                                )),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      controller.notificationLoader
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : readAll
                              ? controller.notificationReadList.isNotEmpty
                                  ? ListView.builder(
                                      itemCount: controller
                                          .notificationReadList.length,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return NotifcationCard(
                                          title: controller
                                              .notificationReadList[index]
                                              .title,
                                          description: controller
                                              .notificationReadList[index]
                                              .description,
                                          date: controller
                                              .notificationReadList[index]
                                              .notificationDate,
                                          taskId: controller
                                              .notificationReadList[index]
                                              .taskId,
                                              docType: controller
                                              .notificationReadList[index]
                                              .docType,
                                        );
                                      })
                                  : const Center(
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 25),
                                        child: Text(
                                          "No data available",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black87),
                                        ),
                                      ),
                                    )
                              : controller.notificationUnreadList.isNotEmpty
                                  ? ListView.builder(
                                      itemCount: controller
                                          .notificationUnreadList.length,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return NotifcationCard(
                                          title: controller
                                              .notificationUnreadList[index]
                                              .title,
                                          description: controller
                                              .notificationUnreadList[index]
                                              .description,
                                          date: controller
                                              .notificationUnreadList[index]
                                              .notificationDate,
                                          taskId: controller
                                              .notificationUnreadList[index]
                                              .taskId,
                                              docType: controller
                                              .notificationUnreadList[index]
                                              .docType,
                                        );
                                      },
                                    )
                                  : const Center(
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 25),
                                        child: Text(
                                          "No data available",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black87),
                                        ),
                                      ),
                                    ),
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }
}

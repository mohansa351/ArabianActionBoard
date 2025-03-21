import 'package:bizlogika_app/screens/dashboard/dashboard_tasks_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/credential_controller.dart';
import '../../controllers/task_controller.dart';
import '../../firebase/fcm_helper.dart';
import '../../utils/common_widgets.dart';
import '../../utils/constants.dart';
import 'home_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedTask = "Today's Task";
  final ScrollController _scrollController = ScrollController();
  int day = 0;
  String token = "";

  List<String> taskList = [
    "Today's Task",
    "Yesterday Task",
    "1 Week Task",
    "1 Month Task",
    "All Tasks",
  ];

  @override
  void initState() {
    super.initState();
    FCM().setNotifications(context);
    Future.microtask(
        () => Get.find<TaskController>().getDashboardTasks(0, true, false));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskController>(
      builder: (TaskController controller) {
        return NotificationListener(
          onNotification: (notification) {
            if (notification is ScrollEndNotification) {
              if (_scrollController.position.pixels ==
                  _scrollController.position.maxScrollExtent) {
                if (_selectedTask == "Today's Task") {
                  controller.getDashboardTasks(0, false, true);
                } else if (_selectedTask == "Yesterday Task") {
                  controller.getDashboardTasks(1, false, true);
                } else if (_selectedTask == "1 Week Task") {
                  controller.getDashboardTasks(2, false, true);
                } else if (_selectedTask == "1 Month Task") {
                  controller.getDashboardTasks(3, false, true);
                } else {
                  controller.getDashboardTasks(4, false, true);
                }
              }
            }
            return false;
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      const Text(
                        "Filter",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 15),
                      Container(
                        width: 170,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(2),
                            border: Border.all(color: Colors.black26)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 10),
                        child: DropdownButtonFormField<String>(
                          elevation: 0,
                          dropdownColor: Colors.white,
                          value: _selectedTask,
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          decoration: const InputDecoration(
                            border: InputBorder.none, // Removes the underline
                            isDense:
                                true, // Adjusts the height to fit the content
                            contentPadding:
                                EdgeInsets.zero, // Adjusts the inner padding
                          ),
                          items: taskList.map((String item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue == "Today's Task") {
                              controller.getDashboardTasks(0, true, false);
                              day = 0;
                              _selectedTask = newValue.toString();
                              setState(() {});
                            } else if (newValue == "Yesterday Task") {
                              controller.getDashboardTasks(1, true, false);
                              day = 1;
                              _selectedTask = newValue.toString();
                              setState(() {});
                            } else if (newValue == "1 Week Task") {
                              controller.getDashboardTasks(2, true, false);
                              day = 2;
                              _selectedTask = newValue.toString();
                              setState(() {});
                            } else if (newValue == "1 Month Task") {
                              controller.getDashboardTasks(3, true, false);
                              day = 3;
                              _selectedTask = newValue.toString();
                              setState(() {});
                            } else {
                              controller.getDashboardTasks(4, true, false);
                              day = 4;
                              _selectedTask = newValue.toString();
                              setState(() {});
                            }
                          },
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 35),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomHomeBox(
                        title: "Approved\nTask",
                        txtClr: approvedTxtColor,
                        value: "${controller.approvedTasks}",
                        boxClr: approvedBackgroundColor,
                        width: screenWidth(context) / 2 - 25,
                        onTap: () {
                          //  token = await credentialController.getOAuthToken();
                          //   // print(token);
                          //   setState(() {

                          //   });
                          //   print(token);
                          //   print(">>>>>>>>>>>>>>>>>");

                            // print(Get.find<AuthController>().userData!.fcmToken);
                          Get.to(() => DashboardTasksListScreen(
                              title: "Approved",
                              searchKey: "APPROVED",
                              day: day));
                        },
                      ),
                      CustomHomeBox(
                        title: "Completed\nTask",
                        txtClr: completedTxtColor,
                        value: "${controller.completedTasks}",
                        boxClr: completedBackgroundColor,
                        width: screenWidth(context) / 2 - 25,
                        onTap: () {
                          Get.to(() => DashboardTasksListScreen(
                              title: "Completed",
                              searchKey: "COMPLETED",
                              day: day));
                        },
                      )
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomHomeBox(
                        title: "Rejected\nTask",
                        txtClr: rejectedTxtColor,
                        value: "${controller.rejectedTasks}",
                        boxClr: rejectedBackgroundColor,
                        width: screenWidth(context) / 2 - 25,
                        onTap: () {
                          // Get.find<AuthController>().updateFcmToken();
                          Get.to(() => DashboardTasksListScreen(
                              title: "Rejected",
                              searchKey: "REJECTED",
                              day: day));
                        },
                      ),
                      CustomHomeBox(
                        title: "Pending\nTask",
                        txtClr: pendingTxtColor,
                        value: "${controller.pendingTasks}",
                        boxClr: pendingBackgroundColor,
                        width: screenWidth(context) / 2 - 25,
                        onTap: () async {
                          Get.to(() => DashboardTasksListScreen(
                              title: "Pending",
                              searchKey: "PENDING",
                              day: day));
                        },
                      )
                    ],
                  ),
                  const SizedBox(height: 15),
                  CustomHomeBox(
                    title: "All Task",
                    txtClr: urgentTxtColor,
                    value: "${controller.allTasks}",
                    boxClr: urgentBackgroundColor,
                    onTap: () async {
                      // token = await credentialController.getOAuthToken();
                      // setState(() {

                      // });
                    },
                  ),
                  const SizedBox(height: 35),
                  Text(
                    " $_selectedTask",
                    // "$token",
                    // "$token",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 20),
                  controller.dashboardLoader
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : controller.dashboardTaskList.isNotEmpty
                          ? ListView.builder(
                              itemCount: controller.dashboardTaskList.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, int index) {
                                return DashboardTaskCard(
                                  task: controller.dashboardTaskList[index],
                                );
                              })
                          : const Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 25),
                                child: Text(
                                  "No tasks available",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87),
                                ),
                              ),
                            ),
                  controller.isLoadingMore
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : const SizedBox()
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

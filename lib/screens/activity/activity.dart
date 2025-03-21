import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/task_controller.dart';
import '../../utils/common_widgets.dart';
import '../../utils/constants.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    // Future.microtask(() => Get.find<TaskController>().getAllActivity(false));
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
                // controller.getAllActivity(true);
              }
            }
            return false;
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Activity',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 20),
                  const SizedBox(height: 10),
                  controller.activityLoader
                      ? Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        )
                      : controller.taskActivity.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.taskActivity.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: lightPurpleColor,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            getFirstLetterUppercase(controller
                                                .taskActivity[index].user),
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.purple.shade700),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                          controller
                                              .taskActivity[index].taskName,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600)),
                                      Text(
                                          formatTimestamp(controller
                                              .taskActivity[index].date),
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w500)),
                                      Row(
                                        children: [
                                          Text(
                                              controller
                                                  .taskActivity[index].user,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600)),
                                          const SizedBox(width: 5),
                                          Text(
                                              '${controller.taskActivity[index].action} to',
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.w400)),
                                          const SizedBox(width: 5),
                                          Text(
                                              controller
                                                  .taskActivity[index].status,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0XFF101828),
                                                  fontWeight: FontWeight.w600)),
                                        ],
                                      ),
                                      const Divider()
                                    ],
                                  ),
                                );
                              },
                            )
                          : const Padding(
                              padding: EdgeInsets.symmetric(vertical: 30),
                              child: Center(
                                child: Text(
                                  "No Activity",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}






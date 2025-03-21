
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/task_controller.dart';
import '../../utils/common_widgets.dart';
import '../../utils/constants.dart';

class TaskActivityScreen extends StatefulWidget {
  const TaskActivityScreen({super.key});

  @override
  State<TaskActivityScreen> createState() => _TaskActivityScreenState();
}

class _TaskActivityScreenState extends State<TaskActivityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(),
      body: GetBuilder<TaskController>(
        builder: (TaskController controller) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.arrow_back_ios, size: 20),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Activity Logs",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
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
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(0),
                                    leading: Container(
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
                                        )),
                                    title: Text(
                                        formatTimestamp(controller
                                            .taskActivity[index].date),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w500)),
                                    subtitle: Row(
                                      children: [
                                        Text(
                                            controller.taskActivity[index].user,
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
          );
        },
      ),
    );
  }
}

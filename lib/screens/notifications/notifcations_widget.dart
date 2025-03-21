import 'package:bizlogika_app/controllers/task_controller.dart';
import 'package:bizlogika_app/screens/task/task_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/constants.dart';

class NotifcationCard extends StatelessWidget {
  const NotifcationCard(
      {super.key,
      required this.title,
      required this.description,
      required this.date,
      required this.taskId,
      required this.docType});

  final String title;
  final String description;
  final String date;
  final String taskId;
  final String docType;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (taskId != "" && taskId != "null") {
          Future.microtask(
              () => Get.find<TaskController>().getTaskDetails(taskId, docType));
              print(taskId);
              print(docType);
          Get.to(() => TaskDetailScreen(taskId: taskId, docType: docType));
        } 
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor)),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 5),
            const Divider(),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  date,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:bizlogika_app/screens/project_estimation/task_estimation_screen.dart';
import 'package:bizlogika_app/screens/job%20card/job_card_screen.dart';
import '../../controllers/task_controller.dart';
import '../../utils/common_widgets.dart';
import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import 'task_update_screen.dart';
import 'package:get/get.dart';
import 'task_activity.dart';


class TaskDetailScreen extends StatefulWidget {
  const TaskDetailScreen(
      {super.key,
      required this.taskId,
      this.notification,
      required this.docType});

  final String taskId;
  final String docType;
  final bool? notification;

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.notification == true) {
      Future.microtask(() => Get.find<TaskController>()
          .getTaskDetails(widget.taskId, widget.docType));
    }
    Future.microtask(() => Get.find<TaskController>()
        .getTaskActivity(widget.taskId, widget.docType));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(),
      bottomNavigationBar: GetBuilder<TaskController>(
        builder: (TaskController controller) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: controller.taskLoader
                ? const SizedBox()
                : controller.taskDetail != null
                    ? controller.taskDetail!.currentStatus == "Pending"
                        ? CustomButton(
                            title: "Update Task",
                            onTap: () {
                              Get.to(
                                () => TaskUpdateScreen(
                                  taskId: widget.taskId,
                                  taskName: controller.taskDetail!.taskName,
                                  receiverId: controller.taskDetail!.receiverId,
                                  docType: widget.docType,
                                ),
                              );
                            },
                          )
                        : const SizedBox()
                    : const SizedBox(),
          );
        },
      ),
      body: GetBuilder<TaskController>(
        builder: (TaskController controller) {
          return controller.taskLoader
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : controller.taskDetail != null
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 25),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Icon(Icons.arrow_back_ios),
                                      ),
                                      const SizedBox(width: 10),
                                      const Text(
                                        "Tasks",
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: statusBackgroundColor(controller
                                            .taskDetail!.currentStatus),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3, horizontal: 10),
                                      child: Text(
                                        controller.taskDetail!.currentStatus,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: statusTxtColor(controller
                                                .taskDetail!.currentStatus)),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: borderColor)),
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.taskDetail!.taskName,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),

                                  const SizedBox(height: 5),
                                  Text(
                                    controller.taskDetail!.docType,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    controller.taskDetail!.docNumber,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                  ),
                                  controller.taskDetail!.inQueue == "NA"
                                      ? const SizedBox()
                                      : const SizedBox(height: 10),
                                  controller.taskDetail!.inQueue == "NA"
                                      ? const SizedBox()
                                      : Row(
                                          children: [
                                            Text(
                                              "In Queue",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  color: primaryColor),
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              controller.taskDetail!.inQueue,
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Icon(Icons.calendar_month,
                                          color: primaryColor),
                                      const SizedBox(width: 10),
                                      Text(
                                        formatTimestamp(
                                            controller.taskDetail!.taskDate),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.menu_open,
                                        color: Colors.black45,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          controller.taskDetail!.project,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black54),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // const SizedBox(height: 10),
                                  // Row(
                                  //   children: [
                                  //     const Icon(
                                  //       Icons.menu,
                                  //       color: Colors.black45,
                                  //     ),
                                  //     const SizedBox(width: 10),
                                  //     Expanded(
                                  //       child: Text(
                                  //         controller
                                  //             .taskDetail!.projectDescription,
                                  //         style: const TextStyle(
                                  //             fontSize: 14,
                                  //             fontWeight: FontWeight.w500,
                                  //             color: Colors.black54),
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      const Icon(Icons.person,
                                          color: Colors.black54),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          controller
                                              .taskDetail!.stakeholderName,
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black54),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      const Icon(Icons.money,
                                          color: Colors.black),
                                      const SizedBox(width: 10),
                                      controller.taskDetail!.amount == "null" ||
                                              controller.taskDetail!.amount ==
                                                  "" ||
                                              controller.taskDetail!.amount ==
                                                  "NA"
                                          ? Expanded(
                                              child: Text(
                                                controller.taskDetail!.amount,
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black),
                                              ),
                                            )
                                          : Expanded(
                                              child: Text(
                                                "${controller.taskDetail!.amount} ${controller.taskDetail!.currency}",
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black),
                                              ),
                                            ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(() => const TaskActivityScreen());
                                    },
                                    child: const Text(
                                      "View Activity Logs",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.blue),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            controller.taskDetail!.projectId != "null" &&
                                    controller.taskDetail!.projectId != ""
                                ? GestureDetector(
                                    onTap: () {
                                      Get.to(() => JobCardScreen(
                                          projectId: controller
                                              .taskDetail!.projectId));
                                    },
                                    child: const Card(
                                      color: Colors.white,
                                      child: ListTile(
                                        title: Text(
                                          "View Job Card",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black),
                                        ),
                                        trailing: Icon(Icons.arrow_forward_ios),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            const SizedBox(height: 10),
                            controller.taskDetail!.estimationId != "null" &&
                                    controller.taskDetail!.estimationId != ""
                                ? Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Get.to(
                                            () => TaskEstimationScreen(
                                              taskId:
                                                  controller.taskDetail!.taskId,
                                              docType: controller
                                                  .taskDetail!.docType,
                                            ),
                                          );
                                        },
                                        child: const Card(
                                          color: Colors.white,
                                          child: ListTile(
                                            title: Text(
                                              "Project Estimation",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black),
                                            ),
                                            trailing:
                                                Icon(Icons.arrow_forward_ios),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  )
                                : const SizedBox(),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: borderColor)),
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    children: [
                                      Icon(Icons.attach_file_outlined),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          "Attachments",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  controller.activityLoader ||
                                          controller.attachmentLoader
                                      ? Center(
                                          child: CircularProgressIndicator(
                                            color: primaryColor,
                                          ),
                                        )
                                      : controller.attachments.isNotEmpty
                                          ? ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount:
                                                  controller.attachments.length,
                                              itemBuilder: (context, index) {
                                                return controller.attachments[
                                                            index] !=
                                                        ""
                                                    ? GestureDetector(
                                                        onTap: () {
                                                          controller.viewAttachment(
                                                              controller
                                                                      .attachments[
                                                                  index]);
                                                        },
                                                        child: Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                                  bottom: 10),
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .white24,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              border: Border.all(
                                                                  color:
                                                                      borderColor)),
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10),
                                                          child: ListTile(
                                                            leading: const Icon(
                                                                Icons
                                                                    .picture_as_pdf_outlined,
                                                                color:
                                                                    Colors.red,
                                                                size: 30),
                                                            title: Text(
                                                              controller
                                                                      .attachments[
                                                                  index],
                                                              style: const TextStyle(
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : const SizedBox();
                                              })
                                          : const Center(
                                              child: Text(
                                                "No Attachment",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black54),
                                              ),
                                            ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: borderColor)),
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.comment, color: primaryColor),
                                      const SizedBox(width: 10),
                                      const Expanded(
                                        child: Text(
                                          "Comments",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  controller.activityLoader
                                      ? Center(
                                          child: CircularProgressIndicator(
                                            color: primaryColor,
                                          ),
                                        )
                                      : controller.taskRemarks.isNotEmpty
                                          ? ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount:
                                                  controller.taskRemarks.length,
                                              itemBuilder: (context, index) {
                                                return controller
                                                            .taskRemarks[index]
                                                            .remarks !=
                                                        ""
                                                    ? Container(
                                                        margin: const EdgeInsets
                                                            .only(bottom: 10),
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 10,
                                                                vertical: 10),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            border: Border.all(
                                                                color:
                                                                    borderColor)),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              controller
                                                                  .taskRemarks[
                                                                      index]
                                                                  .remarks,
                                                              style: const TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Text(
                                                                  "- ${controller.taskRemarks[index].user}",
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ))
                                                    : const SizedBox();
                                              })
                                          : const Center(
                                              child: Text(
                                                "No Comments",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black54),
                                              ),
                                            ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 25),
                          ],
                        ),
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Center(
                          child: Text(
                            "No task found",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(height: 25),
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            height: 35,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: primaryColor,
                            ),
                            child: const Center(
                              child: Icon(Icons.arrow_back_ios,
                                  size: 30, color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    );
        },
      ),
    );
  }
}

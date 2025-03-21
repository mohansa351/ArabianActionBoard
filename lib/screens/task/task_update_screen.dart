import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/task_controller.dart';
import '../../utils/common_widgets.dart';
import '../../utils/constants.dart';

class TaskUpdateScreen extends StatefulWidget {
  const TaskUpdateScreen(
      {super.key,
      required this.taskId,
      required this.taskName,
      required this.receiverId, required this.docType});

  final String taskId;
  final String docType;
  final String taskName;
  final List<String> receiverId;

  @override
  State<TaskUpdateScreen> createState() => _TaskUpdateScreenState();
}

class _TaskUpdateScreenState extends State<TaskUpdateScreen> {
  final TextEditingController _remarksController = TextEditingController();

  Color statusTxt(String val) {
    if (val == "Approved") {
      return approvedTxtColor;
    } else if (val == "Rejected") {
      return rejectedTxtColor;
    } else {
      return pendingTxtColor;
    }
  }

  Color statusBackground(String val) {
    if (val == "Approved") {
      return approvedBackgroundColor;
    } else if (val == "Rejected") {
      return rejectedBackgroundColor;
    } else {
      return pendingBackgroundColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar(),
        body: GetBuilder<TaskController>(
          builder: (TaskController controller) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.arrow_back_ios),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "  Remark",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _remarksController,
                      maxLines: 5,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        hintText: "Enter your remark",
                        fillColor: Colors.white,
                        filled: true,
                        hintStyle: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: borderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: primaryColor),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: borderColor),
                        ),
                      ),
                    ),
                    const SizedBox(height: 35),
                    controller.taskUpdateLoader
                        ? Center(
                            child: CircularProgressIndicator(
                              color: approvedTxtColor,
                            ),
                          )
                        : controller.taskDetail!.status.isNotEmpty
                            ? ListView.builder(
                                itemCount: controller.taskDetail!.status.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () async {
                                      //  String? token =
                                      //       await Get.find<AuthController>()
                                      //           .getTokenByUserId(
                                      //               credentialController.userId);

                                      //   if (token != null) {
                                      //      print(token);
                                      //     Get.find<NotificationsController>()
                                      //         .firebaseNotification(
                                      //             credentialController.getOAuthToken(), token, "Approved");
                                      //   }
                                      if (_remarksController.text.isNotEmpty) {
                                        controller.updateTaskStatus(
                                            widget.taskId,
                                            controller
                                                .taskDetail!.status[index],
                                            _remarksController.text,
                                            widget.receiverId,
                                            widget.taskName, widget.docType);
                                      } else {
                                        controller.updateTaskStatus(
                                            widget.taskId,
                                            controller
                                                .taskDetail!.status[index],
                                            "",
                                            widget.receiverId,
                                            widget.taskName, widget.docType);
                                      }
                                    },
                                    child: Container(
                                      height: 50,
                                      margin: const EdgeInsets.only(bottom: 10),
                                      decoration: BoxDecoration(
                                          color: statusBackground(controller
                                              .taskDetail!.status[index]),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Center(
                                        child: Text(
                                          controller.taskDetail!.status[index],
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: statusTxt(controller
                                                  .taskDetail!.status[index]),
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            // Row(
                            //     children: [
                            //       Expanded(
                            //         child:
                            //       ),
                            //       const SizedBox(width: 10),
                            //       Expanded(
                            //         child: GestureDetector(
                            //           onTap: () {
                            //             if (_remarksController.text.isNotEmpty) {
                            //               controller.updateTaskStatus(widget.taskId,
                            //                   "Rejected", _remarksController.text);
                            //             } else {
                            //               controller.updateTaskStatus(
                            //                   widget.taskId, "Rejected", "");
                            //             }
                            //           },
                            //           child: Container(
                            //             height: 50,
                            //             decoration: BoxDecoration(
                            //                 color: rejectedBackgroundColor,
                            //                 borderRadius: BorderRadius.circular(20)),
                            //             child: Center(
                            //               child: Text(
                            //                 "Reject",
                            //                 style: TextStyle(
                            //                     fontSize: 16,
                            //                     color: rejectedTxtColor,
                            //                     fontWeight: FontWeight.w600),
                            //               ),
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            : const SizedBox()
                  ],
                ),
              ),
            );
          },
        ));
  }
}

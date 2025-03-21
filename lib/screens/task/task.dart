import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/task_controller.dart';
import '../../utils/common_widgets.dart';
import '../../utils/constants.dart';
import 'search_task_screem.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<String> taskCategories = [
    "All",
    "Pending",
    "Completed Task",
    "Approved Task",
    "Rejected Task"
  ];

  List<String> tasks = ["ALL", "PENDING", "COMPLETED", "APPROVED", "REJECTED"];

  List<Color> txtColor = [
    urgentTxtColor,
    pendingTxtColor,
    completedTxtColor,
    approvedTxtColor,
    rejectedTxtColor
  ];

  List<Color> boxColor = [
    urgentBackgroundColor,
    pendingBackgroundColor,
    completedBackgroundColor,
    approvedBackgroundColor,
    rejectedBackgroundColor
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() => Get.find<TaskController>().updateSelectedIndex(0));
    Future.microtask(() => Get.find<TaskController>().getAllTasks(false));
    // // Add a listener to the scroll controller
    // _scrollController.addListener(() {
    //   if (_scrollController.position.pixels >=
    //       _scrollController.position.maxScrollExtent - 200) {
    //     if (Get.find<TaskController>().isLoadingMore) {
    //       Get.find<TaskController>()
    //           .loadMoreTasks(); // Method for loading more tasks
    //     }
    //   }
    // });
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
                controller.getAllTasks(true);
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
                  const Text(
                    "Tasks",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const SearchTaskScreem());
                    },
                    child: CustomTextField(
                      controller: _searchController,
                      hintText: "Search Task",
                      prefixIcon: const Icon(Icons.search),
                      enabled: false,
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 35,
                    child: ListView.builder(
                      itemCount: taskCategories.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            controller.updateSelectedIndex(index);
                            if (index == 1) {
                              controller.getPendingTasks();
                            }
                            if (index == 3) {
                              controller.getApprovedTasks();
                            } else if (index == 4) {
                              controller.getRejectedTasks();
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 2),
                            decoration: BoxDecoration(
                                color: controller.selectedIndex == index
                                    ? boxColor[index]
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(color: borderColor)),
                            margin: const EdgeInsets.only(right: 10),
                            child: Center(
                              child: Text(
                                taskCategories[index],
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: controller.selectedIndex == index
                                        ? txtColor[index]
                                        : Colors.black54),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 25),
                  controller.taskLoader
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : controller.taskList().isNotEmpty
                          ? ListView.builder(
                              itemCount: controller.taskList().length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return TaskCard(index: index);
                              },
                            )
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

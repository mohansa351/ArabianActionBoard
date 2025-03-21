import 'package:bizlogika_app/controllers/task_controller.dart';
import 'package:bizlogika_app/utils/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardTasksListScreen extends StatefulWidget {
  const DashboardTasksListScreen(
      {super.key,
      required this.title,
      required this.searchKey,
      required this.day});

  final String title;
  final String searchKey;
  final int day;

  @override
  State<DashboardTasksListScreen> createState() =>
      _DashboardTasksListScreenState();
}

class _DashboardTasksListScreenState extends State<DashboardTasksListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Get.find<TaskController>()
        .getDashboardFilteredTasks(widget.day, widget.searchKey));
  }

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
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.arrow_back_ios),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        " ${widget.title} Tasks",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  controller.filterTaskLoader
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : controller.filteredTaskList.isNotEmpty
                          ? ListView.builder(
                              itemCount: controller.filteredTaskList.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, int index) {
                                return FilteredTaskCard(index: index);
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/task_controller.dart';
import '../../utils/common_widgets.dart';
import '../../utils/constants.dart';

class SearchTaskScreem extends StatefulWidget {
  const SearchTaskScreem({super.key});

  @override
  State<SearchTaskScreem> createState() => _SearchTaskScreemState();
}

class _SearchTaskScreemState extends State<SearchTaskScreem> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => Get.find<TaskController>().clearFilteredTaskList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(),
      body: GetBuilder<TaskController>(
        builder: (TaskController controller) {
          return NotificationListener(
            onNotification: (notification) {
              if (notification is ScrollEndNotification) {
                if (_scrollController.position.pixels ==
                    _scrollController.position.maxScrollExtent) {
                  if (controller.filteredTaskList.isNotEmpty) {
                    if (_searchController.text.isNotEmpty) {
                      controller.getSearchedTasks(_searchController.text, true);
                    }
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
                    SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.arrow_back_ios, size: 20),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "Tasks",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _searchController,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      onChanged: (String val) {
                        controller.getSearchedTasks(val, false);
                      },
                      decoration: InputDecoration(
                        labelText: "Search Task",
                        fillColor: Colors.white,
                        filled: true,
                        labelStyle: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500),
                        prefixIcon: const Icon(Icons.search),
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
                    const SizedBox(height: 15),
                    controller.filterTaskLoader
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : controller.filteredTaskList.isNotEmpty
                            ? ListView.builder(
                                itemCount: controller.filteredTaskList.length,
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                                itemBuilder: (context, index) {
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
      ),
    );
  }
}

import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:table_calendar/table_calendar.dart";
import "../../controllers/task_controller.dart";
import "../../utils/common_widgets.dart";
import "../../utils/constants.dart";

class TaskFilterScreen extends StatefulWidget {
  const TaskFilterScreen({super.key});

  @override
  State<TaskFilterScreen> createState() => _TaskFilterScreenState();
}

class _TaskFilterScreenState extends State<TaskFilterScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _startDate; // Start of the selected range
  DateTime? _endDate; // End of the selected range
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  final ScrollController _scrollController = ScrollController();

  String formatDateFromDateTime(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

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
                    if (_startDate != null && _endDate != null) {
                      controller.getFilteredTasks(
                          formatDateFromDateTime(_startDate!),
                          formatDateFromDateTime(_endDate!),
                          true);
                    }
                  }
                }
              }
              return false;
            },
            child: Container(
              width: screenWidth(context),
              // height: screenHeight(context),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 25),
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
                            "Filter",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    TableCalendar(
                      firstDay: DateTime.utc(2010, 10, 16),
                      lastDay: DateTime.utc(2035, 3, 14),
                      focusedDay: _startDate ?? _focusedDay,
                      calendarFormat: CalendarFormat.twoWeeks,
                      rangeSelectionMode: _rangeSelectionMode,
                      selectedDayPredicate: (day) =>
                          isSameDay(day, _startDate) ||
                          isSameDay(day, _endDate),
                      rangeStartDay: _startDate,
                      rangeEndDay: _endDate,
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(
                          () {
                            print(_startDate);
                            if (_startDate == null) {
                              // If there's no start date, set the selected date as the start date
                              _startDate = selectedDay;
                            } else {
                              if (selectedDay.isBefore(_startDate!)) {
                                // If the selected date is before the start date, swap them
                                _endDate = _startDate;
                                _startDate = selectedDay;
                              } else {
                                // If the selected date is after the start date, set it as the end date
                                _endDate = selectedDay;
                              }
                            }
                          },
                        );
                      },
                      // onRangeSelected: _onRangeSelected,
                      availableCalendarFormats: const {
                        CalendarFormat.twoWeeks: '2 Weeks',
                      },
                      headerStyle: const HeaderStyle(
                        titleTextStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        titleCentered: true,
                        formatButtonVisible: false,
                      ),
                      rowHeight: 50,
                      calendarStyle: const CalendarStyle(
                        isTodayHighlighted: true,
                        defaultTextStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        weekendTextStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        selectedTextStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        rangeHighlightColor: Colors.blue,
                        rangeStartDecoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        rangeEndDecoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        cellMargin:
                            EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      ),
                    ),
                    const SizedBox(height: 45),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        _startDate = null;
                        _endDate = null;
                        setState(() {});
                      },
                      child: const Text(
                        "  Clear",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue),
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                        title: "Filter Tasks",
                        onTap: () {
                          if (_startDate != null && _endDate != null) {
                            controller.getFilteredTasks(
                                formatDateFromDateTime(_startDate!),
                                formatDateFromDateTime(_endDate!),
                                false);
                          }
                        }),
                    const SizedBox(height: 25),
                    controller.filterTaskLoader
                        ? const Center(
                            child: CircularProgressIndicator(),
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

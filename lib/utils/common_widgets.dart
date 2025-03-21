import 'package:bizlogika_app/controllers/notifications_controller.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import '../controllers/credential_controller.dart';
import '../controllers/task_controller.dart';
import '../models/task_model.dart' as task_model;
import '../screens/notifications/notification_screen.dart';
import '../screens/task/task_detail_screen.dart';
import 'constants.dart';

showToast(String msg) {
  return Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: primaryColor,
    textColor: Colors.white,
    fontSize: 15.0,
  );
}

////
////
String nullCheckValue(String val) {
  if (val != "null" && val != "") {
    return val;
  } else {
    return "NA";
  }
}

////
////
String formatDate(String isoDate) {
  try {
    if (isoDate != "" && isoDate != "null") {
      // Parse the ISO 8601 date string
      DateTime parsedDate = DateTime.parse(isoDate);

      // Format the date as "dd MMM yyyy"
      String formattedDate = DateFormat('dd MMM yyyy').format(parsedDate);

      return formattedDate;
    } else {
      return "-";
    }
  } catch (e) {
    // Handle errors gracefully
    return '-';
  }
}

////
////
statusTxtColor(String val) {
  if (val == "Completed") {
    return completedTxtColor;
  } else if (val == "Approved") {
    return approvedTxtColor;
  } else if (val == "Rejected") {
    return rejectedTxtColor;
  } else {
    return pendingTxtColor;
  }
}

statusBackgroundColor(String val) {
  if (val == "Completed") {
    return completedBackgroundColor;
  } else if (val == "Approved") {
    return approvedBackgroundColor;
  } else if (val == "Rejected") {
    return rejectedBackgroundColor;
  } else {
    return pendingBackgroundColor;
  }
}

////
Future<String> calculateStartDate(int num) async {
  try {
    DateTime date;

    // Determine the start date based on the value of `num`
    if (num == 0) {
      date = DateTime.now();
      return "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}";
    } else if (num == 1) {
      date = DateTime.now().subtract(const Duration(days: 1));
      return "${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    } else if (num == 2) {
      date = DateTime.now().subtract(const Duration(days: 7));
      return "${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    } else if (num == 3) {
      date = DateTime.now().subtract(const Duration(days: 30));
      return "${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    } else {
      return ""; // Return an empty string for invalid `num`
    }
  } catch (e) {
    print("Error: ${e.toString()}");
    return "Error arised";
  }
}

Future<String> calculateEndDate(int num) async {
  try {
    DateTime date;
    if (num == 1) {
      // Current date
      date = DateTime.now();
    } else {
      // Tomorrow's date
      date = DateTime.now().add(const Duration(days: 1));
    }

    // Format the date as a string
    String year = date.year.toString();
    String month = date.month.toString().padLeft(2, '0');
    String day = date.day.toString().padLeft(2, '0');

    if (num == 4) {
      return '';
    } else {
      return '$year-$month-$day';
    }
  } catch (e) {
    print("Error: ${e.toString()}");
    return "";
  }
}

////
////
String formatTimestamp(String isoTimestamp) {
  if (isoTimestamp != "" && isoTimestamp != "null")
  // Parse the ISO 8601 timestamp
  {
    DateTime dateTime = DateTime.parse(isoTimestamp);

    // Format the date into "dd MMM, yyyy • EEEE"
    String formattedDate = DateFormat('dd MMM, yyyy • EEEE').format(dateTime);

    return formattedDate;
  } else {
    return "";
  }
}

////
////
bool isToday(String isoDate) {
  try {
    // Parse the ISO 8601 date string
    DateTime parsedDate = DateTime.parse(isoDate);

    // Get today's date
    DateTime today = DateTime.now();

    // Check if the year, month, and day match
    return parsedDate.year == today.year &&
        parsedDate.month == today.month &&
        parsedDate.day == today.day;
  } catch (e) {
    // Handle errors gracefully
    return false;
  }
}

////
////
String trimToken(String token) {
  // Check if the token contains a semicolon (;)
  if (token.contains(';')) {
    // Split the string at the first semicolon and return the first part
    return token.split(';')[0];
  }
  // Return the original token if no semicolon is found
  return token;
}

////
////
String getFirstLetterUppercase(String value) {
  if (value.isEmpty) {
    return ''; // Return empty string if input is empty
  }
  return value[0].toUpperCase();
}
////
////
//// Custom App Bar used in project

AppBar customAppBar() {
  return AppBar(
    automaticallyImplyLeading: false,
    title: Row(
      children: [Image.asset(logo, width: 150)],
    ),
    actions: [
      GetBuilder<NotificationsController>(
        builder: (NotificationsController controller) {
          return GestureDetector(
            onTap: () {
              if (controller.unreadNotifcationCount != "") {
                Get.to(() => const NotificationScreen());
              }
            },
            child: Stack(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  child: GestureDetector(
                    onTap: () {
                      if (controller.unreadNotifcationCount == "") {
                        Get.to(() => const NotificationScreen());
                      }
                    },
                    child: Image.asset(notification, height: 25),
                  ),
                ),
                controller.unreadNotifcationCount != ""
                    ? Positioned(
                        right: 3,
                        top: 0,
                        bottom: 16,
                        child: Container(
                            height: 20,
                            width: 20,
                            // padding: const EdgeInsets.symmetric(
                            //     horizontal: 2, vertical: 0),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Center(
                              child: Text(
                                controller.unreadNotifcationCount,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )),
                      )
                    : const SizedBox(),
              ],
            ),
          );
        },
      ),
      const SizedBox(width: 25)
    ],
  );
}

////
////
//// Custom TextField used in project

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      this.prefixIcon,
      this.keyboardType,
      this.obscureText,
      this.suffixIcon,
      this.enabled,
      this.maxLines});

  final TextEditingController controller;
  final String hintText;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final Widget? suffixIcon;
  final int? maxLines;
  final bool? enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled ?? true,
      keyboardType: keyboardType ?? TextInputType.text,
      obscureText: obscureText ?? false,
      maxLines: maxLines ?? 1,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        labelText: hintText,
        fillColor: Colors.white,
        filled: true,
        labelStyle: const TextStyle(
            fontSize: 16, color: Colors.black54, fontWeight: FontWeight.w500),
        prefixIcon: prefixIcon ?? const SizedBox(),
        suffixIcon: suffixIcon ?? const SizedBox(),
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
    );
  }
}

////
////
//// Custom TextField used in project

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.title, required this.onTap});

  final String title;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            right: BorderSide(color: primaryColor, width: 4),
            bottom: BorderSide(color: primaryColor, width: 4),
          ),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: primaryColor),
          ),
        ),
      ),
    );
  }
}

////
////
//// Custom Loader used in app
class CustomLoader extends StatelessWidget {
  const CustomLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: primaryColor, width: 4),
          bottom: BorderSide(color: primaryColor, width: 4),
        ),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Center(
          child: CircularProgressIndicator(
        color: primaryColor,
      )),
    );
  }
}

checkEmptyString(val) {
  if (val.toString().removeAllWhitespace == "") {
    return null;
  } else {
    return val;
  }
}

////
////
//// Custom Task card used in project

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskController>(
      builder: (TaskController controller) {
        return GestureDetector(
          onTap: () {
            Future.microtask(() => controller.getTaskDetails(
                controller.taskList()[index].id.toString(),
                controller.taskList()[index].documentType.toString()));

            Get.to(() => TaskDetailScreen(
                taskId: controller.taskList()[index].id.toString(),
                docType: controller.taskList()[index].documentType.toString()));
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
                  controller.taskList()[index].name ?? "NA",
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                Text(
                  checkEmptyString(controller.taskList()[index].projectName) ??
                      controller.taskList()[index].narration ??
                      controller.taskList()[index].stackHolderName ??
                      "NA",
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                Text(
                  controller.taskList()[index].documentType ?? "NA",
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 10),
                Text(
                  controller.taskList()[index].docNo ?? "NA",
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 10),
                Text(
                  controller.taskList()[index].stackHolderName ?? "NA",
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 5),
                const Divider(),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: statusBackgroundColor(
                            controller.taskList()[index].currentStatus ?? "NA"),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 3, horizontal: 10),
                      child: Text(
                        (controller.taskList()[index].currentStatus ?? "NA"),
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: statusTxtColor(
                                controller.taskList()[index].currentStatus ??
                                    "-")),
                      ),
                    ),
                    // const SizedBox(width: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Icon(Icons.attach_file_outlined),
                        const SizedBox(width: 5),
                        Text(
                          formatDate(
                              controller.taskList()[index].created ?? ""),
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

////
////
//// Custom Task card used in project

class DashboardTaskCard extends StatelessWidget {
  const DashboardTaskCard({super.key, required this.task});

  final task_model.AllTask task;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Future.microtask(() => Get.find<TaskController>()
            .getTaskDetails(task.id.toString(), task.documentType.toString()));
        Get.to(() => TaskDetailScreen(
              taskId: task.id.toString(),
              docType: task.documentType.toString(),
            ));
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
              task.name ?? "NA",
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Text(
              checkEmptyString(task.projectName) ??
                  task.narration ??
                  task.stackHolderName ??
                  "NA",
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Text(
              task.documentType ?? "NA",
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 10),
            Text(
              task.docNo ?? "NA",
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 10),
            Text(
              task.stackHolderName ?? "NA",
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
              textAlign: TextAlign.justify,
            ),

            // Text(
            //   task.name ?? "-",
            //   style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            // ),
            // const SizedBox(height: 10),
            // Text(
            //   task.documentType ?? "-",
            //   style: const TextStyle(
            //       fontSize: 14,
            //       fontWeight: FontWeight.w500,
            //       color: Colors.black54),
            //   textAlign: TextAlign.justify,
            // ),
            const SizedBox(height: 5),
            const Divider(),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: statusBackgroundColor(task.currentStatus ?? "NA"),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                  child: Text(
                    (task.currentStatus ?? "NA"),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: statusTxtColor(task.currentStatus ?? "NA"),
                    ),
                  ),
                ),
                // const SizedBox(width: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Icon(Icons.attach_file_outlined),
                    const SizedBox(width: 5),
                    Text(
                      formatDate(task.created ?? ""),
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

/// Custom List Tile used in project

class CustomListTile extends StatelessWidget {
  final String avatarImage;
  final String title;
  final String subtitle;
  final Function onTap;

  const CustomListTile({
    super.key,
    required this.avatarImage,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onTap();
      },
      contentPadding: const EdgeInsets.only(left: 5),
      leading: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage(avatarImage),
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Color(0XFF101828),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
            fontSize: 12,
            color: Color(0XFF344054),
            fontWeight: FontWeight.w400),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 18,
        color: Color(0XFF475467),
      ),
    );
  }
}

////
////
//// Custom Task card used in project

class FilteredTaskCard extends StatelessWidget {
  const FilteredTaskCard({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskController>(
      builder: (TaskController controller) {
        return GestureDetector(
          onTap: () {
            Future.microtask(() => controller.getTaskDetails(
                controller.filteredTaskList[index].id.toString(),
                controller.filteredTaskList[index].documentType.toString()));
            Get.to(() => TaskDetailScreen(
                taskId: controller.filteredTaskList[index].id.toString(),
                docType: controller.filteredTaskList[index].documentType
                    .toString()));
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
                  controller.filteredTaskList[index].name ?? "NA",
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                Text(
                  checkEmptyString(controller.filteredTaskList[index].projectName) ??
                      controller.filteredTaskList[index].narration ??
                      controller.filteredTaskList[index].stackHolderName ??
                      "NA",
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                Text(
                  controller.filteredTaskList[index].documentType ?? "NA",
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 10),
                Text(
                  controller.filteredTaskList[index].docNo ?? "NA",
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 10),
                Text(
                  controller.filteredTaskList[index].stackHolderName ?? "NA",
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                  textAlign: TextAlign.justify,
                ),

                // Text(
                //   controller.filteredTaskList[index].name ?? "-",
                //   style: const TextStyle(
                //       fontSize: 17, fontWeight: FontWeight.w600),
                // ),
                // const SizedBox(height: 10),
                // Text(
                //   controller.filteredTaskList[index].documentType ?? "-",
                //   style: const TextStyle(
                //       fontSize: 14,
                //       fontWeight: FontWeight.w500,
                //       color: Colors.black54),
                //   textAlign: TextAlign.justify,
                // ),
                const SizedBox(height: 5),
                const Divider(),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: statusBackgroundColor(
                            controller.filteredTaskList[index].currentStatus ??
                                "NA"),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 3, horizontal: 10),
                      child: Text(
                        (controller.filteredTaskList[index].currentStatus ??
                            "NA"),
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: statusTxtColor(controller
                                    .filteredTaskList[index].currentStatus ??
                                "NA")),
                      ),
                    ),
                    // const SizedBox(width: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Icon(Icons.attach_file_outlined),
                        const SizedBox(width: 5),
                        Text(
                          formatDate(
                              controller.filteredTaskList[index].created ?? ""),
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

logoutDialog(BuildContext context) {
  Dialogs.materialDialog(
    msg: 'Do you want to logout?',
    title: "Logout",
    color: Colors.white,
    titleStyle: TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor),
    msgStyle: const TextStyle(
        fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),
    msgAlign: TextAlign.center,
    titleAlign: TextAlign.center,
    context: context,
    actionsBuilder: (context) {
      return [
        IconsButton(
          onPressed: () {
            Navigator.pop(context);
          },
          text: 'Cancel',
          iconData: Icons.cancel,
          color: Colors.red.shade700,
          textStyle: const TextStyle(color: Colors.white, fontSize: 14),
          iconColor: Colors.white,
        ),
        IconsButton(
          onPressed: () {
            credentialController.logoutUser();
          },
          text: 'Logout',
          iconData: Icons.logout,
          color: primaryColor,
          textStyle: const TextStyle(color: Colors.white, fontSize: 14),
          iconColor: Colors.white,
        ),
      ];
    },
  );
}

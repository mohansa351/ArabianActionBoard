import 'dart:convert';
import 'dart:io';
import 'package:bizlogika_app/controllers/auth_controller.dart';
import 'package:bizlogika_app/models/job_card_model.dart';
import 'package:bizlogika_app/models/notification_model.dart';
import 'package:bizlogika_app/models/task_estimation_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import '../models/activity_model.dart';
import '../models/task_detail_model.dart';
import '../models/task_model.dart' as task_model;
import '../models/task_model.dart';
import '../utils/common_widgets.dart';
import '../utils/constants.dart';
import 'credential_controller.dart';
import 'notifications_controller.dart';

class TaskController extends GetxController {
  List<task_model.AllTask> allTaskList = [];
  List<task_model.Pending> pendingTaskList = [];
  List<task_model.Rejected> rejectedTaskList = [];
  List<task_model.Approved> approvedTaskList = [];
  List<task_model.Completed> completedTaskList = [];
  List<task_model.AllTask> dashboardTaskList = [];
  List<task_model.AllTask> filteredTaskList = [];
  List<ActivityModel> taskActivity = [];
  List<ActivityModel> allActivities = [];
  List<RemarkModel> taskRemarks = [];
  List<String> attachments = [];
  TaskDetailModel? taskDetail;

  bool taskLoader = false;
  bool activityLoader = false;
  bool taskUpdateLoader = false;
  bool dashboardLoader = false;
  bool filterTaskLoader = false;
  int selectedIndex = 0;

  /// Tasks count
  int approvedTasks = 0;
  int completedTasks = 0;
  int rejectedTasks = 0;
  int pendingTasks = 0;
  int allTasks = 0;

  updateSelectedIndex(int index) {
    selectedIndex = index;
    update();
  }

  List taskList() {
    int index = selectedIndex;
    if (index == 0) {
      return allTaskList;
    } else if (index == 1) {
      return pendingTaskList;
    } else if (index == 2) {
      return completedTaskList;
    } else if (index == 3) {
      return approvedTaskList;
    } else if (index == 4) {
      return rejectedTaskList;
    } else {
      return [];
    }
  }

  updateTaskLoader(bool val, bool more) {
    if (val) {
      if (more) {
        isLoadingMore = val;
        update();
      } else {
        taskLoader = val;
        update();
      }
    } else {
      taskLoader = val;
      isLoadingMore = val;
      update();
    }
  }

  updateDashboardLoader(bool val, bool more) {
    if (val) {
      if (more) {
        isLoadingMore = val;
        update();
      } else {
        dashboardLoader = val;
        update();
      }
    } else {
      dashboardLoader = val;
      isLoadingMore = val;
      update();
    }
  }

  updateFilterLoader(bool val, bool more) {
    if (val) {
      if (more) {
        isLoadingMore = val;
        update();
      } else {
        filterTaskLoader = val;
        update();
      }
    } else {
      filterTaskLoader = val;
      isLoadingMore = val;
      update();
    }
  }

  updateActivityLoader(bool val, bool more) {
    if (val) {
      if (more) {
        isLoadingMore = val;
        update();
      } else {
        activityLoader = val;
        update();
      }
    } else {
      activityLoader = val;
      isLoadingMore = val;
      update();
    }

    update();
  }

  updateTaskUpdateLoader(bool val) {
    taskUpdateLoader = val;
    update();
  }

  ////
  ////
  //// Get all tasks based on status
  int currentPage = 1;
  bool isLoadingMore = false;
  int taskLength = 0;

  updateCurrentPage() {
    currentPage = 1;
    allTaskList.clear();
    completedTaskList.clear();
    approvedTaskList.clear();
    update();
  }

  Future<void> getAllTasks(bool isMore) async {
    updateTaskLoader(true, isMore);

    if (!isMore) {
      updateCurrentPage();
    }

    print(currentPage);

    try {
      print(credentialController.userCookie);
      var headers = {
        'Content-Type': 'application/json',
        'Cookie': credentialController.userCookie
      };
      var request = http.Request('POST', Uri.parse(getTasksUrl));
      request.body = json.encode({
        "pagination": {"page": currentPage, "limit": 100},
        "filter": "", //REJECTED, COMPLETED, ALL, PENDING, APPROVED , ""
        "search": "",
        "fromDate": "",
        "toDate": "",
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      print(response.reasonPhrase);
      print(response.statusCode);

      if (response.statusCode == 200) {
        final res = await response.stream.bytesToString();
        var responseData = json.decode(res);

        print(responseData);

        if (responseData["success"] == true) {
          TaskModel model = TaskModel.fromJson(responseData);
          if (model.data != null) {
            if (model.data!.completed != "" &&
                model.data!.completed != null &&
                model.data!.completed!.isNotEmpty) {
              if (currentPage == 1) {
                completedTaskList = model.data!.completed ?? [];
              } else {
                completedTaskList.addAll(model.data!.completed ?? []);
              }
            }
            if (model.data!.allTask != "" &&
                model.data!.allTask != null &&
                model.data!.allTask!.isNotEmpty) {
              //  allTaskList = model.data!.allTask!;
              if (currentPage == 1) {
                allTaskList = model.data!.allTask ?? [];
                ++currentPage;
              } else {
                allTaskList.addAll(model.data!.allTask ?? []);
                ++currentPage;
              }
            }
            update();
          }
        } else {
          showToast(responseData["errors"].toString());
        }
      } else {
        final res = await response.stream.bytesToString();
        var responseData = json.decode(res);

        if (responseData["message"] == "session expired") {
          credentialController.logoutUser();
          showToast("Session expired");
        }
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e.toString());
      print(">>>>>>>>>>>>.");
    } finally {
      updateTaskLoader(false, false);
    }
  }

  Future<void> getPendingTasks() async {
    updateTaskLoader(true, false);
    pendingTaskList.clear();

    try {
      print(credentialController.userCookie);
      var headers = {
        'Content-Type': 'application/json',
        'Cookie': credentialController.userCookie
      };
      var request = http.Request('POST', Uri.parse(getTasksUrl));
      request.body = json.encode({
        "pagination": {"page": "", "limit": ""},
        "filter": "PENDING", //REJECTED, COMPLETED, ALL, PENDING, APPROVED , ""
        "search": "",
        "fromDate": "",
        "toDate": "",
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final res = await response.stream.bytesToString();
        var responseData = json.decode(res);

        print(responseData);

        if (responseData["success"] == true) {
          List<dynamic> tasks = responseData["data"]["tasks"] ?? [];

          if (tasks.isNotEmpty) {
            for (var task in tasks) {
              task_model.Pending model = task_model.Pending.fromJson(task);
              pendingTaskList.add(model);
            }
          }

          update();
        } else {
          showToast(responseData["errors"].toString());
        }
      } else {
        final res = await response.stream.bytesToString();
        var responseData = json.decode(res);

        if (responseData["message"] == "session expired") {
          credentialController.logoutUser();
          showToast("Session expired");
        }
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e.toString());
    } finally {
      updateTaskLoader(false, false);
    }
  }

  Future<void> getRejectedTasks() async {
    updateTaskLoader(true, false);
    pendingTaskList.clear();

    try {
      print(credentialController.userCookie);
      var headers = {
        'Content-Type': 'application/json',
        'Cookie': credentialController.userCookie
      };
      var request = http.Request('POST', Uri.parse(getTasksUrl));
      request.body = json.encode({
        "pagination": {"page": "", "limit": ""},
        "filter": "REJECTED", //REJECTED, COMPLETED, ALL, PENDING, APPROVED , ""
        "search": "",
        "fromDate": "",
        "toDate": "",
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final res = await response.stream.bytesToString();
        var responseData = json.decode(res);

        print(responseData);

        if (responseData["success"] == true) {
          List<dynamic> tasks = responseData["data"]["tasks"] ?? [];

          if (tasks.isNotEmpty) {
            for (var task in tasks) {
              task_model.Rejected model = task_model.Rejected.fromJson(task);
              rejectedTaskList.add(model);
            }
          }

          update();
        } else {
          showToast(responseData["errors"].toString());
        }
      } else {
        final res = await response.stream.bytesToString();
        var responseData = json.decode(res);

        if (responseData["message"] == "session expired") {
          credentialController.logoutUser();
          showToast("Session expired");
        }
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e.toString());
    } finally {
      updateTaskLoader(false, false);
    }
  }

  Future<void> getApprovedTasks() async {
    updateTaskLoader(true, false);
    pendingTaskList.clear();

    try {
      print(credentialController.userCookie);
      var headers = {
        'Content-Type': 'application/json',
        'Cookie': credentialController.userCookie
      };
      var request = http.Request('POST', Uri.parse(getTasksUrl));
      request.body = json.encode({
        "pagination": {"page": "", "limit": ""},
        "filter": "APPROVED", //REJECTED, COMPLETED, ALL, PENDING, APPROVED , ""
        "search": "",
        "fromDate": "",
        "toDate": "",
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final res = await response.stream.bytesToString();
        var responseData = json.decode(res);

        print(responseData);

        if (responseData["success"] == true) {
          List<dynamic> tasks = responseData["data"]["tasks"] ?? [];

          if (tasks.isNotEmpty) {
            for (var task in tasks) {
              task_model.Approved model = task_model.Approved.fromJson(task);
              approvedTaskList.add(model);
            }
          }

          update();
        } else {
          showToast(responseData["errors"].toString());
        }
      } else {
        final res = await response.stream.bytesToString();
        var responseData = json.decode(res);

        if (responseData["message"] == "session expired") {
          credentialController.logoutUser();
          showToast("Session expired");
        }
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e.toString());
    } finally {
      updateTaskLoader(false, false);
    }
  }

  ////
  ////
  //// Get task details
  Future<void> getTaskDetails(String id, String docType) async {
    updateTaskLoader(true, false);

    try {
      taskDetail = null;
      update();
      var headers = {
        'Content-Type': 'application/json',
        'Cookie': credentialController.userCookie
      };
      var request = http.Request('POST', Uri.parse("$getTaskDetailUrl$id"));

      request.headers.addAll(headers);

      request.body = json.encode({"documentType": docType});

      http.StreamedResponse response = await request.send();

      // print(response);

      if (response.statusCode == 200) {
        final res = await response.stream.bytesToString();
        var responseData = json.decode(res);

        print(responseData);

        if (responseData["success"] == true) {
          List<dynamic> details =
              responseData["data"][0]["ApprovalFlowDefinition"][0]["details"];
          List<dynamic> approvalInfo =
              responseData["data"][0]["approvalInfo"]["details"] ?? [];
          List<String> availableStatus = [];
          List<String> nextUserIds = [];
          List<String> nextUserNames = [];
          int approvalSeq = 0;
          String pName = "NA";
          String pDescription = "NA";
          String amountValue = "NA";

          if (approvalInfo.isNotEmpty) {
            var approval = approvalInfo.last;
            approvalSeq = approval["seq"] ?? 0;
          }

          for (int i = 0; i < details.length; i++) {
            var approvalItem = details[i];
            var user = approvalItem['username'].firstWhere(
                (user) =>
                    user['userId'] ==
                    credentialController.userId, // 
                orElse: () => null);

            if (user != null) {
              // Check for the next sequence number
              int currentSeq = approvalItem['seq'];
              List<dynamic> statusValues = approvalItem["status"] ?? [];
              for (var status in statusValues) {
                availableStatus.add(status);
              }

              // Check if currentSeq is the last sequence number
              bool isLastSeq = currentSeq ==
                  details.map((e) => e['seq']).reduce((a, b) => a > b ? a : b);

              if (isLastSeq) {
                // If it's the last sequence number, add all user IDs to nextUserIds
                for (var item in details) {
                  for (var usr in item['username']) {
                    if (credentialController.userId != usr['userId']) {
                      nextUserIds.add(usr['userId'] ?? "");
                    }
                  }
                }
              } else {
                for (int j = i + 1; j < details.length; j++) {
                  var nextApprovalItem = details[j];
                  if (nextApprovalItem['seq'] == currentSeq + 1) {
                    var nextUser = nextApprovalItem['username'].first;
                    nextUserIds.add(nextUser['userId'] ?? "");
                  }
                  if (nextApprovalItem['seq'] == approvalSeq + 1) {
                    var nextUser = nextApprovalItem['username'].first;
                    nextUserNames.add(nextUser['username'] ?? "NA");
                  }
                }
              }
              break; // Exit once we find the matching userId
            }
          }

          print(nextUserIds);
          print(">>>>>>>>>>>>>>");

          String stakeholder = responseData["data"][0]["supplierName"] ?? "";

          if (stakeholder == "") {
            stakeholder = responseData["data"][0]["customerName"] ?? "NA";
          }

          List<dynamic> project =
              responseData["data"][0]["projectDetails"] ?? [];

          if (project.isNotEmpty) {
            pName = responseData["data"][0]["projectDetails"][0]
                    ["projectName"] ??
                "NA";

            pDescription = responseData["data"][0]["projectDetails"][0]
                    ["projectDescription"] ??
                "NA";

            amountValue = fixAmountValues(responseData["data"][0]
                    ["projectDetails"][0]["approxValue"]
                .toString());
          }

          if(pName == "NA"){

            pName = responseData["data"][0]["narration"] ?? stakeholder;

          }

          taskDetail = TaskDetailModel(
            taskId: responseData["data"][0]["_id"].toString(),
            projectId: responseData["data"][0]["projectId"].toString(),
            taskName: responseData["data"][0]["ApprovalFlowDefinition"][0]
                    ["name"]
                .toString(),
            taskDate: responseData["data"][0]["created"].toString(),
            docNumber: responseData["data"][0]["docNo"] ?? "",
            stakeholderName: stakeholder,
            docType: responseData["data"][0]["ApprovalFlowDefinition"][0]
                    ["documentType"]
                .toString(),
            amount: amountValue,
            currency: responseData["data"][0]["currencyShortName"] ?? "",
            project: pName,
            projectDescription: pDescription,
            currentStatus: responseData["data"][0]["currentStatus"].toString(),
            estimationId: responseData["data"][0]["estimationId"].toString(),
            status: availableStatus,
            receiverId: nextUserIds,
            inQueue: nextUserNames.isNotEmpty ? nextUserNames.first : "NA",
          );
          update();
        } else {
          showToast(responseData["errors"].toString());
        }
      } else {
        final res = await response.stream.bytesToString();
        var responseData = json.decode(res);

        if (responseData["message"] == "session expired") {
          credentialController.logoutUser();
          showToast("Session expired");
        }
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e.toString());
    } finally {
      updateTaskLoader(false, false);
    }
  }

  String fixAmountValues(String val) {
    try {
      if (val != "" && val != "null" && val != "0") {
        double amount = double.parse(val);
        return amount.toStringAsFixed(2);
      } else if (val == "" || val == "null") {
        return "NA";
      } else if (val == "0") {
        return "0.00";
      } else {
        return val;
      }
    } catch (e) {
      return val;
    }
  }

  ////
  ////
  //// Get task details
  Future<void> getTaskActivity(String id, String docType) async {
    updateActivityLoader(true, false);
    taskRemarks.clear();
    taskActivity.clear();
    attachments.clear();

    try {
      var headers = {
        'Content-Type': 'application/json',
        'Cookie': credentialController.userCookie
      };
      var request = http.Request('POST', Uri.parse("$getTaskDetailUrl$id"));

      request.headers.addAll(headers);

      request.body = json.encode({"documentType": docType});

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final res = await response.stream.bytesToString();
        var responseData = json.decode(res);

        if (responseData["success"] == true) {
          if (responseData["data"][0]["attachmentsDetails"] != null &&
              responseData["data"][0]["attachmentsDetails"] != [] &&
              responseData["data"][0]["attachmentsDetails"] != "") {
            List<dynamic> attachDetails =
                responseData["data"][0]["attachmentsDetails"];

            for (var attach in attachDetails) {
              attachments.add(attach.toString());
            }
          }

          if (responseData["data"][0]["approvalInfo"] != null &&
              responseData["data"][0]["approvalInfo"] != "" &&
              responseData["data"][0]["approvalInfo"] != []) {
            if (responseData["data"][0]["approvalInfo"] != "" &&
                responseData["data"][0]["approvalInfo"] != null &&
                responseData["data"][0]["approvalInfo"]["details"] != [] &&
                responseData["data"][0]["approvalInfo"]["details"] != "" &&
                responseData["data"][0]["approvalInfo"]["details"] != null) {
              List<dynamic> activities =
                  responseData["data"][0]["approvalInfo"]["details"];

              for (var activity in activities) {
                taskRemarks.add(
                  RemarkModel(
                    user: activity["user"] ?? "",
                    remarks: activity["remark"] ?? "",
                  ),
                );
                taskActivity.add(
                  ActivityModel(
                    user: activity["user"] ?? "",
                    action: activity["action"] ?? "",
                    status: activity["status"] ?? "",
                    date: activity["statusDate"] ?? "",
                    remarks: activity["remark"] ?? "",
                    taskName: "",
                  ),
                );
              }
            }
          }

          update();
        } else {
          showToast(responseData["errors"].toString());
        }
      } else {
        final res = await response.stream.bytesToString();
        var responseData = json.decode(res);

        if (responseData["message"] == "session expired") {
          credentialController.logoutUser();
          showToast("Session expired");
        }
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e.toString());
    } finally {
      updateActivityLoader(false, false);
    }
  }

  Future<void> updateTaskStatus(String id, String statusValue, String remark,
      List<String> receiverId, String taskName, String docType) async {
    updateTaskUpdateLoader(true);
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Cookie': credentialController.userCookie
      };
      var request = http.Request('PATCH', Uri.parse("$getTaskDetailUrl$id"));
      request.body = json.encode({
        "documentType": docType,
        "actionType": statusValue,
        "remark": remark
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        showToast("Status Updated");
        taskDetail!.currentStatus = statusValue;
        update();
        String senderName = Get.find<AuthController>().userData!.firstName;
        getTaskActivity(id, docType);

        Future.microtask(() => sendNotificationsForReceivers(
            receiverId, taskName, statusValue, senderName, id, docType));

        Get.back();
      } else {
        final res = await response.stream.bytesToString();
        var responseData = json.decode(res);

        if (responseData["message"] == "session expired") {
          credentialController.logoutUser();
          showToast("Session expired");
        } else {
          showToast("Failed to update status");
          Get.back();
        }
      }
    } catch (e) {
      print(e.toString());
    } finally {
      updateTaskUpdateLoader(false);
    }
  }

  void sendNotificationsForReceivers(List<String> receiverIds, String taskName,
      String statusValue, String senderName, String id, String documentType) {
    try {
      for (String receiverId in receiverIds) {
        NotificationModel notification = NotificationModel(
            title: taskName,
            description: "Task is updated to $statusValue by $senderName",
            status: statusValue,
            taskId: id,
            senderName: senderName,
            receiverId: receiverId, // Assigning receiverId
            notificationDate: "",
            senderId: "",
            docType: documentType);

        Get.find<NotificationsController>().sendNotification(notification);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  ////
  ////
  //// Get all dashboard tasks
  int dashboardTaskCount = 1;

  updateDashboardTaskCount() {
    dashboardTaskCount = 1;
    update();
  }

  Future<void> getDashboardTasks(int day, bool getCount, bool isMore) async {
    updateDashboardLoader(true, isMore);

    if (getCount) {
      dashboardTaskList.clear();
    }

    if (!isMore) {
      updateDashboardTaskCount();
    }

    try {
      String fromDate = await calculateStartDate(day);
      String endDate = await calculateEndDate(day);

      print(fromDate);
      print(endDate);

      var headers = {
        'Content-Type': 'application/json',
        'Cookie': credentialController.userCookie
      };
      var request = http.Request('POST', Uri.parse(getTasksUrl));
      request.body = json.encode({
        "pagination": {"page": dashboardTaskCount, "limit": 100},
        "filter": "", //REJECTED, COMPLETED, ALL, PENDING, APPROVED , ""
        "search": "",
        "fromDate": fromDate,
        "toDate": endDate,
      });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final res = await response.stream.bytesToString();
        var responseData = json.decode(res);

        print(responseData);

        if (responseData["success"] == true) {
          TaskModel model = TaskModel.fromJson(responseData);
          if (model.data != null) {
            if (getCount) {
              approvedTasks = model.data!.approvedTaskCount ?? 0;
              completedTasks = model.data!.completedTaskCount ?? 0;
              rejectedTasks = model.data!.rejectedTaskCount ?? 0;
              pendingTasks = model.data!.pendingTaskCount ?? 0;
              allTasks = model.data!.allTaskCount ?? 0;
            }
            if (model.data!.allTask != null &&
                model.data!.allTask!.isNotEmpty &&
                model.data!.allTask != "") {
              if (dashboardTaskCount == 1) {
                dashboardTaskList = model.data!.allTask!;
                print(dashboardTaskList.length);
                dashboardTaskCount++;
              } else {
                dashboardTaskList.addAll(model.data!.allTask!);
                print(dashboardTaskList.length);
                dashboardTaskCount++;
              }
            }

            update();
          }
        } else {
          showToast(responseData["errors"].toString());
        }
      } else {
        final res = await response.stream.bytesToString();
        var responseData = json.decode(res);

        if (responseData["message"] == "session expired") {
          credentialController.logoutUser();
          showToast("Session expired");
        }
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e.toString());
    } finally {
      updateDashboardLoader(false, false);
    }
  }

  clearFilteredTaskList() {
    filteredTaskList.clear();
    update();
  }

  Future<void> getDashboardFilteredTasks(int day, String key) async {
    updateFilterLoader(true, false);
    clearFilteredTaskList();

    try {
      String fromDate = await calculateStartDate(day);
      String endDate = await calculateEndDate(day);

      print(fromDate);
      print(endDate);

      var headers = {
        'Content-Type': 'application/json',
        'Cookie': credentialController.userCookie
      };
      var request = http.Request('POST', Uri.parse(getTasksUrl));
      request.body = json.encode({
        "pagination": {"page": 1, "limit": 100},
        "filter": key, //REJECTED, COMPLETED, ALL, PENDING, APPROVED , ""
        "search": "",
        "fromDate": fromDate,
        "toDate": endDate,
      });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final res = await response.stream.bytesToString();
        var responseData = json.decode(res);

        print(responseData);

        if (responseData["success"] == true) {
          if (responseData["data"] != null) {
            List<dynamic> tasks = responseData["data"]["tasks"] ?? [];
            if (tasks.isNotEmpty) {
              for (var task in tasks) {
                filteredTaskList.add(task_model.AllTask.fromJson(task));
              }
            }
            update();
          }
        } else {
          showToast(responseData["errors"].toString());
        }
      } else {
        final res = await response.stream.bytesToString();
        var responseData = json.decode(res);

        if (responseData["message"] == "session expired") {
          credentialController.logoutUser();
          showToast("Session expired");
        }
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e.toString());
    } finally {
      updateFilterLoader(false, false);
    }
  }

  ////
  ////
  //// Get filtered tasks
  int filteredTaskPage = 1;

  updateFilteredTask() {
    filteredTaskPage = 1;
    update();
  }

  Future<void> getFilteredTasks(
      String startDate, String endDate, bool loadMore) async {
    updateFilterLoader(true, loadMore);

    if (!loadMore) {
      filteredTaskList.clear();
      updateFilteredTask();
    }

    print(startDate);
    print(endDate);

    try {
      var headers = {
        'Content-Type': 'application/json',
        'Cookie': credentialController.userCookie
      };
      var request = http.Request('POST', Uri.parse(getTasksUrl));
      request.body = json.encode({
        "pagination": {"page": filteredTaskPage, "limit": 100},
        "filter": "", //REJECTED, COMPLETED, ALL, PENDING, APPROVED , ""
        "search": "",
        "fromDate": startDate,
        "toDate": endDate,
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final res = await response.stream.bytesToString();
        var responseData = json.decode(res);

        print(responseData);

        if (responseData["success"] == true) {
          TaskModel model = TaskModel.fromJson(responseData);
          if (model.data != null) {
            if (model.data!.allTask!.isNotEmpty &&
                model.data!.allTask != "" &&
                model.data!.allTask != null) {
              if (filteredTaskPage == 1) {
                filteredTaskList = model.data!.allTask!;
                filteredTaskPage++;
              } else {
                filteredTaskList.addAll(model.data!.allTask!);
                filteredTaskPage++;
              }
            }

            update();
          }
        } else {
          showToast(responseData["errors"].toString());
        }
      } else {
        final res = await response.stream.bytesToString();
        var responseData = json.decode(res);

        if (responseData["message"] == "session expired") {
          credentialController.logoutUser();
          showToast("Session expired");
        }
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e.toString());
    } finally {
      updateFilterLoader(false, false);
    }
  }

  ////
  ////
  //// Get search tasks
  Future<void> getSearchedTasks(String search, bool loadMore) async {
    updateFilterLoader(true, loadMore);

    if (!loadMore) {
      filteredTaskList.clear();
      updateFilteredTask();
    }

    try {
      var headers = {
        'Content-Type': 'application/json',
        'Cookie': credentialController.userCookie
      };
      var request = http.Request('POST', Uri.parse(getTasksUrl));
      request.body = json.encode({
        "pagination": {"page": filteredTaskPage, "limit": 100},
        "filter": "", //REJECTED, COMPLETED, ALL, PENDING, APPROVED , ""
        "search": search,
        "fromDate": "",
        "toDate": "",
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final res = await response.stream.bytesToString();
        var responseData = json.decode(res);

        print(responseData);

        if (responseData["success"] == true) {
          TaskModel model = TaskModel.fromJson(responseData);
          if (model.data != null) {
            if (model.data!.allTask!.isNotEmpty &&
                model.data!.allTask != "" &&
                model.data!.allTask != null) {
              if (filteredTaskPage == 1) {
                filteredTaskList = model.data!.allTask!;
                print(filteredTaskList.length);
                filteredTaskPage++;
              } else {
                filteredTaskList.addAll(model.data!.allTask!);
                print(filteredTaskList.length);
                filteredTaskPage++;
              }
            }

            update();
          }
        } else {
          showToast(responseData["errors"].toString());
        }
      } else {
        final res = await response.stream.bytesToString();
        var responseData = json.decode(res);

        if (responseData["message"] == "session expired") {
          credentialController.logoutUser();
          showToast("Session expired");
        }
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e.toString());
    } finally {
      updateFilterLoader(false, false);
    }
  }

////
////
  int currentActivityPage = 1;

  updateCurrentActivityPage() {
    currentActivityPage = 1;
    update();
  }

  // Future<void> getAllActivity(bool loadMore) async {
  //   updateActivityLoader(true, loadMore);

  //   if (!loadMore) {
  //     allActivities.clear();
  //     updateCurrentActivityPage();
  //   }

  //   try {
  //     var headers = {
  //       'Content-Type': 'application/json',
  //       'Cookie': credentialController.userCookie
  //     };
  //     var request = http.Request('POST', Uri.parse(getAllActivityUrl));
  //     request.body = json.encode({
  //       "fromDate": "",
  //       "toDate": "",
  //       "pagination": {"page": currentActivityPage, "limit": 5}
  //     });

  //     request.headers.addAll(headers);

  //     http.StreamedResponse response = await request.send();

  //     if (response.statusCode == 200) {
  //       final res = await response.stream.bytesToString();
  //       var responseData = json.decode(res);

  //       print(responseData);

  //       if (responseData["success"] == true) {
  //         List<dynamic> data = responseData["data"]["data"];

  //         if (data != null && data.isNotEmpty) {
  //           for (var activity in data) {
  //             taskActivity.add(
  //               ActivityModel(
  //                 user: activity["user"] ?? "",
  //                 action: activity["action"] ?? "",
  //                 status: activity["status"] ?? "",
  //                 date: activity["statusDate"] ?? "",
  //                 remarks: activity["remark"] ?? "",
  //                 taskName: activity["taskName"] ?? "",
  //               ),
  //             );
  //           }

  //           currentActivityPage++;
  //           update();
  //         }

  //         update();
  //       } else {
  //         showToast(responseData["errors"].toString());
  //       }
  //     } else {
  //       print(response.reasonPhrase);
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //   } finally {
  //     updateActivityLoader(false, false);
  //   }
  // }

////
////
////
  Future<String?> generateAccessToken(bool email) async {
    try {
      String userEmail = Get.find<AuthController>().userData!.email;

      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST', Uri.parse(generateAccessTokenUrl));
      request.body = json.encode({
        "username": email ? userEmail : credentialController.userName,
        "password": credentialController.password,
        "isClient": false,
        "isChannel": false
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final res = await response.stream.bytesToString();
        var responseData = json.decode(res);
        print(credentialController.userName);
        print(responseData);
        return responseData["token"];
      } else {
        final res = await response.stream.bytesToString();
        var responseData = json.decode(res);

        if (responseData["message"] == "session expired") {
          credentialController.logoutUser();
          showToast("Session expired");
        }
        print(response.reasonPhrase);
        return "";
      }
    } catch (e) {
      print(e.toString());
      return "";
    }
  }

  bool attachmentLoader = false;

  Future<void> viewAttachment(String pdf) async {
    attachmentLoader = true;
    update();

    try {
      String accessToken = await generateAccessToken(false) ?? "";

      if (accessToken == "" && accessToken.isEmpty) {
        String accessToken = await generateAccessToken(true) ?? "";

        print(accessToken);

        if (accessToken != "" && accessToken.isNotEmpty) {
          var headers = {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'x-access-token': accessToken
          };
          var request = http.Request('GET', Uri.parse('$getAttachmentUrl$pdf'));

          request.headers.addAll(headers);

          http.StreamedResponse response = await request.send();

          if (response.statusCode == 200) {
            final directory = await getTemporaryDirectory();
            final filePath = '${directory.path}/$pdf';

            // Save the file locally
            final file = File(filePath);
            final bytes = await response.stream.toBytes();
            await file.writeAsBytes(bytes);

            // Open the file
            await OpenFile.open(filePath);
          } else {
            print(response.reasonPhrase);
          }
        }
      } else {
        var headers = {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'x-access-token': accessToken
        };
        var request = http.Request('GET', Uri.parse('$getAttachmentUrl$pdf'));

        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          final directory = await getTemporaryDirectory();
          final filePath = '${directory.path}/$pdf';

          // Save the file locally
          final file = File(filePath);
          final bytes = await response.stream.toBytes();
          await file.writeAsBytes(bytes);

          // Open the file
          await OpenFile.open(filePath);
        } else {
          print(response.reasonPhrase);
        }
      }
    } catch (e) {
      print(e.toString());
    } finally {
      attachmentLoader = false;
      update();
    }
  }

  /////
  /////
  ///// Fetch task estimation and job card details
  TaskEstimationModel? taskEstimation;
  List<TaskItemModel> estimatedItemsList = [];
  Future<void> fetchEstimation(String taskId, String docType) async {
    updateJobLoader(true);
    estimatedItemsList.clear();
    taskEstimation = null;
    update();

    try {
      var headers = {
        'Content-Type': 'application/json',
        'Cookie': credentialController.userCookie,
      };
      var request =
          http.Request('POST', Uri.parse("$getTaskEstimationUrl$taskId"));
      request.body = json.encode({"documentType": docType});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final res = await response.stream.bytesToString();

        var responseData = json.decode(res);
        print(responseData);
        if (responseData["success"] == true) {
          var data = responseData["data"];
          if (data != null && data != "") {
            taskEstimation = TaskEstimationModel(
              project: data["projectName"] ?? "",
              customer: data["customerName"] ?? "",
              estimation: data["estimationCode"] ?? "",
              opportunity: data["opportunityCode"] ?? "",
              date: data["date"] ?? "",
              grossProjectValue:
                  fixAmountValues(data["grossProjectValue"].toString()),
              discount: fixAmountValues(data["discount"].toString()),
              outputVAT: fixAmountValues(data["outputVAT"].toString()),
              projectValue: fixAmountValues(data["projectValue"].toString()),
              remarks: data["remarks"] ?? "",
              totalCost: fixAmountValues(data["totalCost"].toString()),
              totalsales: fixAmountValues(data["totalSales"].toString()),
              overheads: fixAmountValues(data["overHead"].toString()),
              onBillDiscount:
                  fixAmountValues(data["onbilldiscount"].toString()),
              vatOverCost: fixAmountValues(data["vatOverCost"].toString()),
              vatActualSales:
                  fixAmountValues(data["vatActualSales"].toString()),
              totalOverCost: fixAmountValues(data["totalOverCost"].toString()),
              actualSales: fixAmountValues(data["actualSales"].toString()),
              totalMarkup: fixAmountValues(data["totalMarkup"].toString()),
              totalMarkupPercent: fixAmountValues(
                          data["totalMarkupPercentage"].toString()) ==
                      "NA"
                  ? fixAmountValues(data["totalMarkupPercentage"].toString())
                  : "${fixAmountValues(data["totalMarkupPercentage"].toString())}%",
            );

            List<dynamic> rowData = data["rowData"] ?? [];

            if (rowData.isNotEmpty) {
              for (var row in rowData) {
                estimatedItemsList.add(
                  TaskItemModel(
                    itemCode: row["materialCode"] ?? "",
                    description: row["materialDescription"] ?? "",
                    quantity: row["qty"].toString(),
                    unit: row["unit"].toString(),
                    salesAmount: fixAmountValues(row["grossAmount"].toString()),
                    salesPrice: fixAmountValues(row["pricePerUnit"].toString()),
                    estimatedCost:
                        fixAmountValues(row["estimatedPrice"].toString()),
                    totalEstimatedCost:
                        fixAmountValues(row["totalEstimated"].toString()),
                    markup: fixAmountValues(row["markupAmount"].toString()),
                    markupPercent: fixAmountValues(
                                row["markupPercentage"].toString()) ==
                            "NA"
                        ? fixAmountValues(row["markupPercentage"].toString())
                        : "${fixAmountValues(row["markupPercentage"].toString())}%",
                  ),
                );
              }
            }

            update();
          }
        } else {
          print(responseData);
        }
      } else {
        final res = await response.stream.bytesToString();
        var responseData = json.decode(res);

        if (responseData["message"] == "session expired") {
          credentialController.logoutUser();
          showToast("Session expired");
        }
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e.toString());
    } finally {
      updateJobLoader(false);
    }
  }

////
////

  ProjectDetailsModel? projectDetails;
  ProjectEstimationModel? projectEstimation;
  SalesCollectionModel? salesCollections;
  PurchaseCollectionModel? purchaseCollections;
  List<VariationsModel> variationsList = [];
  SalesReceiptModel? salesReceipt;
  ProfitAndMarkupDetails? profitAndMarkupDetails;
  PurchasePaymentDetails? purchasePaymentDetails;

  List<PurchaseDetails> purchaseDetailsList = [];
  List<ReceiptsCollected> receiptsList = [];
  List<PendingInvoices> pendingInvoicesList = [];
  List<InvoicesNotIssued> invoicesNotIssuedList = [];
  List<PendingSO> pendingSOList = [];

  List<OverheadDirectInvoice> overheadDirectInvoiceList = [];
  List<OverheadAgainstDirectPV> overheadAgainstDirectPVList = [];
  List<JournalVoucher> journalVoucherList = [];

  updateJobDetails() {
    projectDetails = null;
    projectEstimation = null;
    salesCollections = null;
    purchaseCollections = null;
    variationsList = [];
    salesReceipt = null;
    profitAndMarkupDetails = null;
    purchasePaymentDetails = null;
    purchaseDetailsList = [];
    receiptsList = [];
    pendingInvoicesList = [];
    invoicesNotIssuedList = [];
    pendingSOList = [];
    overheadDirectInvoiceList = [];
    overheadAgainstDirectPVList = [];
    journalVoucherList = [];
    update();
  }

  Future<void> fetchJobCardDetails(String projectId) async {
    updateJobDetails();
    updateTaskLoader(true, false);

    try {
      String companyCode = Get.find<AuthController>().userData!.companyCode;

      // JSON object that needs to be encoded
      Map<String, dynamic> selectParams = {
        "projectId": projectId,
        "reportType": "Job Card"
      };

      String encodedParams = Uri.encodeComponent(jsonEncode(selectParams));

      String apiUrl =
          "$getJobCardUrl?companyCode=$companyCode&selectParams=$encodedParams";

      print("Request URL: $apiUrl");

      var request = http.Request('GET', Uri.parse(apiUrl));

      http.StreamedResponse response = await request.send();

      // Check response status
      if (response.statusCode == 200) {
        final res = await response.stream.bytesToString();
        var responseData = json.decode(res);
        if (responseData["success"] == true) {
          List<dynamic> salesOrderInfo =
              responseData["data"]["salesOrderInfo"] ?? [];

          List<dynamic> revision = responseData["data"]["revisions"] ?? [];

          if (salesOrderInfo.isNotEmpty) {
            /// Project details
            projectDetails = ProjectDetailsModel(
              projectCode: responseData["data"]["projectMasterDetails"]
                      ["projectCode"] ??
                  "",
              projectName: responseData["data"]["projectMasterDetails"]
                      ["projectName"] ??
                  "",
              clientName: responseData["data"]["projectMasterDetails"]
                      ["customer"]["customerName"] ??
                  "",
              salesOrderNumber: salesOrderInfo[0]["salesOrderCode"] ?? "",
              maxRevisionNo: "${revision.length}", /////////////////////
              salesOrderDate: salesOrderInfo[0]["salesOrderDate"] ?? "",
              lpo: salesOrderInfo[0]["customerPO"] ?? "",
              currency:
                  salesOrderInfo[0]["exchangeCurrency"]["shortForm"] ?? "",

              exchangeRate:
                  fixAmountValues(salesOrderInfo[0]["exchangeRate"].toString()),
              initialProjectValue: fixAmountValues(responseData["data"]
                      ["projectDetails"]["initialProjectValue"]
                  .toString()),
              variation: fixAmountValues(responseData["data"]["projectDetails"]
                      ["variation"]
                  .toString()),
              totalProjectValue: fixAmountValues(responseData["data"]
                      ["projectDetails"]["totalProjectValue"]
                  .toString()),
              totalProjectVAT: fixAmountValues(responseData["data"]
                      ["projectDetails"]["totalProjectTax"]
                  .toString()),
              totalProjectValueWithVAT: fixAmountValues(responseData["data"]
                      ["projectDetails"]["totalProjectValueWithTax"]
                  .toString()),
            );
          }

          /// Estimation details
          projectEstimation = ProjectEstimationModel(
            initialEstCost: fixAmountValues(responseData["data"]
                    ["estimationDetails"]["initialEstimationCost"]
                .toString()),
            variation: fixAmountValues(responseData["data"]["estimationDetails"]
                    ["variation"]
                .toString()),
            totalEstCost: fixAmountValues(responseData["data"]
                    ["estimationDetails"]["totalEstCost"]
                .toString()),
            totalActCost: fixAmountValues(responseData["data"]
                    ["estimationDetails"]["totalActCost"]
                .toString()),
            overhead: fixAmountValues(responseData["data"]["estimationDetails"]
                    ["overhead"]
                .toString()),
          );

          /// Sales collection details
          salesCollections = SalesCollectionModel(
            collectAgainstDel: fixAmountValues(responseData["data"]
                    ["salesCollectionDetails"]["paidAmount"]
                .toString()),
            advFromCustomer: fixAmountValues(responseData["data"]
                    ["salesCollectionDetails"]["advanceReceipt"]
                .toString()),
            totalCollection: fixAmountValues(responseData["data"]
                    ["salesCollectionDetails"]["totalCollection"]
                .toString()),
            advanceInvoice: fixAmountValues(responseData["data"]
                    ["salesCollectionDetails"]["advanceInvoice"]
                .toString()),
          );

          /// Purchase collection detail
          purchaseCollections = PurchaseCollectionModel(
            paidAgainstDel: fixAmountValues(responseData["data"]
                    ["purchaseCollectionDetails"]["paidAmount"]
                .toString()),
            advPaidToSupp: fixAmountValues(responseData["data"]
                    ["purchaseCollectionDetails"]["prePaymentPaidAmount"]
                .toString()),
            paidFromPv: fixAmountValues(responseData["data"]
                    ["purchaseCollectionDetails"]["paidFromPV"]
                .toString()),
            debitNote: fixAmountValues(responseData["data"]
                    ["purchaseCollectionDetails"]["debitNoteAmount"]
                .toString()),
            reservation: fixAmountValues(responseData["data"]
                    ["purchaseCollectionDetails"]["reservation"]
                .toString()),
            grossTotalPaid: fixAmountValues(responseData["data"]
                    ["purchaseCollectionDetails"]["grossTotalPaid"]
                .toString()),
            projectTransfer: fixAmountValues(responseData["data"]
                    ["purchaseCollectionDetails"]["projectTransfer"]
                .toString()),
            totalPaid: fixAmountValues(responseData["data"]
                    ["purchaseCollectionDetails"]["totalPaid"]
                .toString()),
            cashFlow: fixAmountValues(responseData["data"]
                    ["purchaseCollectionDetails"]["cashflow"]
                .toString()),
          );

          /// Variations
          List<dynamic> salesOrders =
              responseData["data"]["salesOrderInfo"] ?? [];

          if (salesOrders.isNotEmpty) {
            for (var salesOrder in salesOrders) {
              variationsList.add(
                VariationsModel(
                  transactionNo: salesOrder["salesOrderCode"] ?? "",
                  lpo: salesOrder["customerPO"] ?? "",
                  date: salesOrder["salesOrderDate"] ?? "",
                  sales: fixAmountValues(salesOrder["accountDetailsTable"]
                          ["grossAmount"]
                      .toString()),
                  cost: fixAmountValues(salesOrder["accountDetailsTable"]
                          ["totalCalculation"]["estimatedGross"]
                      .toString()),
                ),
              );
            }
          }

          /// Sales receipt details
          salesReceipt = SalesReceiptModel(
            totalSalesVal: fixAmountValues(responseData["data"]
                    ["salesReceiptDetails"]["totalSalesInvoiceGross"]
                .toString()),
            delieveredSIWVat: fixAmountValues(responseData["data"]
                    ["salesReceiptDetails"]["totalReceiptSalesInvoiceGross"]
                .toString()),
            delieveredSIWithVat: fixAmountValues(responseData["data"]
                    ["salesReceiptDetails"]["totalReceiptNet"]
                .toString()),
            delieveredReceivable: fixAmountValues(responseData["data"]
                    ["salesReceiptDetails"]["pendingReceiptNet"]
                .toString()),
            projectReceivable: fixAmountValues(responseData["data"]
                    ["salesReceiptDetails"]["projectReceivable"]
                .toString()),
          );

          /// Profit and markup details
          profitAndMarkupDetails = ProfitAndMarkupDetails(
            totalEstProfit: fixAmountValues(responseData["data"]
                    ["profitMarkUpDetails"]["totalMarkUp"]
                .toString()),
            totalActProfit: fixAmountValues(responseData["data"]
                    ["profitMarkUpDetails"]["totalActProfit"]
                .toString()),
            estMargin: fixAmountValues(responseData["data"]
                            ["profitMarkUpDetails"]["estMarginPerc"]
                        .toString()) ==
                    "NA"
                ? fixAmountValues(responseData["data"]["profitMarkUpDetails"]
                        ["estMarginPerc"]
                    .toString())
                : "${fixAmountValues(responseData["data"]["profitMarkUpDetails"]["estMarginPerc"].toString())}%",
            actMargin: fixAmountValues(responseData["data"]
                            ["profitMarkUpDetails"]["actualMarginPerc"]
                        .toString()) ==
                    "NA"
                ? fixAmountValues(responseData["data"]["profitMarkUpDetails"]
                        ["actualMarginPerc"]
                    .toString())
                : "${fixAmountValues(responseData["data"]["profitMarkUpDetails"]["actualMarginPerc"].toString())}%",
            estMarkup: fixAmountValues(responseData["data"]
                            ["profitMarkUpDetails"]["estMarkPerc"]
                        .toString()) ==
                    "NA"
                ? fixAmountValues(responseData["data"]["profitMarkUpDetails"]
                        ["estMarkPerc"]
                    .toString())
                : "${fixAmountValues(responseData["data"]["profitMarkUpDetails"]["estMarkPerc"].toString())}%",
            actMarkup: fixAmountValues(responseData["data"]
                            ["profitMarkUpDetails"]["actMarkPerc"]
                        .toString()) ==
                    "NA"
                ? fixAmountValues(responseData["data"]["profitMarkUpDetails"]
                        ["actMarkPerc"]
                    .toString())
                : "${fixAmountValues(responseData["data"]["profitMarkUpDetails"]["actMarkPerc"].toString())}%",
          );

          /// Purchase payment details
          purchasePaymentDetails = PurchasePaymentDetails(
            delieveredPI: fixAmountValues(responseData["data"]
                    ["purchasePaymentDetails"]["totalInvGrossAmount"]
                .toString()),
            payablesAgainstPI: fixAmountValues(
                "${responseData["data"]["purchasePaymentDetails"]["pendingPIGross"]}"),
            projectPayablesWithVAT: fixAmountValues(
                "${responseData["data"]["purchasePaymentDetails"]["projectPayable"]}"),
            exchangeRates: "0.00",
            vatInput: fixAmountValues(
                "${responseData["data"]["taxDetails"]["taxInput"]}"),
            vatOutput: fixAmountValues(
                "${responseData["data"]["taxDetails"]["taxOutput"]}"),
            netVat: fixAmountValues(
                "${responseData["data"]["taxDetails"]["netVat"]}"),
          );

          update();
          // generatePdfFromTaskJobModel(projectDetails!, projectEstimation!, salesCollections!, purchaseCollections!);
        }
      } else {
        final res = await response.stream.bytesToString();
        var responseData = json.decode(res);

        if (responseData["message"] == "session expired") {
          credentialController.logoutUser();
          showToast("Session expired");
        }
        print("Error: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (e) {
      print(e.toString());
    } finally {
      updateTaskLoader(false, false);
    }
  }

//////////////
  bool jobLoader = false;

  updateJobLoader(bool val) {
    jobLoader = val;
    update();
  }

  Future<void> fetchPurchaseDetails(String projectId) async {
    updateJobLoader(true);

    try {
      String companyCode = Get.find<AuthController>().userData!.companyCode;

      // JSON object that needs to be encoded
      Map<String, dynamic> selectParams = {
        "projectId": projectId,
        "reportType": "Job Card"
      };

      String encodedParams = Uri.encodeComponent(jsonEncode(selectParams));

      String apiUrl =
          "$getJobCardUrl?companyCode=$companyCode&selectParams=$encodedParams";

      print("Request URL: $apiUrl");

      var request = http.Request('GET', Uri.parse(apiUrl));

      http.StreamedResponse response = await request.send();

      // Check response status
      if (response.statusCode == 200) {
        final res = await response.stream.bytesToString();
        var responseData = json.decode(res);
        if (responseData["success"] == true) {
          /// Purchase details
          List<dynamic> purchaseInfo =
              responseData["data"]["purchaseInfo"] ?? [];

          if (purchaseInfo.isNotEmpty) {
            for (var purchase in purchaseInfo) {
              List<dynamic> details = purchase["details"] ?? [];

              purchaseDetailsList.add(
                PurchaseDetails(
                  orderRef: purchase["POCode"].toString(),
                  date: purchase["PODate"].toString(),
                  supplierName:
                      purchase["supplier"]["suplierCompanyName"].toString(),
                  itemCode: details[0]["materialCode"] ?? "",
                  description: details[0]["materialDescription"] ?? "",
                  quantity: details[0]["qty"].toString(),
                  unitPrice:
                      fixAmountValues(details[0]["pricePerUnit"].toString()),
                  budgetValue: "0.00",
                  foreignOrder: "N/A",
                  orderAmt:
                      fixAmountValues(details[0]["grossAmount"].toString()),
                  amtSettled: "0.00",
                  balance: "0.00",
                ),
              );

              for (var detail in details.skip(1)) {
                purchaseDetailsList.add(
                  PurchaseDetails(
                    orderRef: "",
                    date: "",
                    supplierName: "",
                    itemCode: detail["materialCode"] ?? "",
                    description: detail["materialDescription"] ?? "",
                    quantity: detail["qty"].toString(),
                    unitPrice:
                        fixAmountValues(detail["pricePerUnit"].toString()),
                    budgetValue: "0.00",
                    foreignOrder: "N/A",
                    orderAmt: fixAmountValues(detail["grossAmount"].toString()),
                    amtSettled: "0.00",
                    balance: "0.00",
                  ),
                );
              }
            }
            update();
          }
        }
      } else {
        final res = await response.stream.bytesToString();
        var responseData = json.decode(res);

        if (responseData["message"] == "session expired") {
          credentialController.logoutUser();
          showToast("Session expired");
        }
        print("Error: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (e) {
      print(e.toString());
    } finally {
      updateJobLoader(false);
    }
  }

////////////
  Future<void> fetchSalesDetails(String projectId) async {
    updateJobLoader(true);
    try {
      String companyCode = Get.find<AuthController>().userData!.companyCode;

      // JSON object that needs to be encoded
      Map<String, dynamic> selectParams = {
        "projectId": projectId,
        "reportType": "Job Card"
      };

      String encodedParams = Uri.encodeComponent(jsonEncode(selectParams));

      String apiUrl =
          "$getJobCardUrl?companyCode=$companyCode&selectParams=$encodedParams";

      print("Request URL: $apiUrl");

      var request = http.Request('GET', Uri.parse(apiUrl));

      http.StreamedResponse response = await request.send();

      // Check response status
      if (response.statusCode == 200) {
        final res = await response.stream.bytesToString();
        var responseData = json.decode(res);
        if (responseData["success"] == true) {
          /// Receipts collected
          List<dynamic> receiptsCollected =
              responseData["data"]["receiptsCollected"] ?? [];

          if (receiptsCollected.isNotEmpty) {
            for (var receipt in receiptsCollected) {
              receiptsList.add(
                ReceiptsCollected(
                  transactionNo: receipt["transactionNo"].toString(),
                  againstReference: receipt["againstReferenceNo"].toString(),
                  amount: fixAmountValues(receipt["amount"].toString()),
                ),
              );
            }
          }

          /// Pending Invoices
          List<dynamic> unpaidSalesInvoices =
              responseData["data"]["unPaidSalesInvoices"] ?? [];

          if (unpaidSalesInvoices.isNotEmpty) {
            for (var invoice in unpaidSalesInvoices) {
              pendingInvoicesList.add(
                PendingInvoices(
                  transactionNo: invoice["transactionNo"].toString(),
                  balance: fixAmountValues(invoice["balance"].toString()),
                  amount: fixAmountValues(invoice["amount"].toString()),
                  status: invoice["status"].toString(),
                ),
              );
            }
          }

          /// Invoices not issued
          List<dynamic> invoicesNotIssued =
              responseData["data"]["invoiceNotIssued"] ?? [];

          if (invoicesNotIssued.isNotEmpty) {
            for (var invoice in invoicesNotIssued) {
              invoicesNotIssuedList.add(
                InvoicesNotIssued(
                  transactionNo: invoice["transactionNo"].toString(),
                  amount: fixAmountValues(invoice["amount"].toString()),
                  status: invoice["status"].toString(),
                ),
              );
            }
          }

          /// Pending SO
          List<dynamic> pendingSo =
              responseData["data"]["pendingForDelivery"] ?? [];

          if (pendingSo.isNotEmpty) {
            for (var so in pendingSo) {
              if (so["pendingQty"] != null && so["pendingQty"] != "") {
                if (so["pendingQty"] == 0) {
                  pendingSOList.add(
                    PendingSO(
                      transactionNo: so["transactionNo"].toString(),
                      transactionDate: so["date"].toString(),
                      pendingAmt: fixAmountValues(so["amount"].toString()),
                      status: "Delivered",
                    ),
                  );
                } else {
                  pendingSOList.add(
                    PendingSO(
                      transactionNo: so["transactionNo"].toString(),
                      transactionDate: so["date"].toString(),
                      pendingAmt: fixAmountValues(so["amount"].toString()),
                      status: "To be delivered",
                    ),
                  );
                }
              }
            }
          }
          update();
        }
      } else {
        final res = await response.stream.bytesToString();
        var responseData = json.decode(res);

        if (responseData["message"] == "session expired") {
          credentialController.logoutUser();
          showToast("Session expired");
        }
        print("Error: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (e) {
      print(e.toString());
    } finally {
      updateJobLoader(false);
    }
  }

//////////////
  Future<void> fetchOverheadDirectInvoice(String projectId) async {
    updateJobLoader(true);
    try {
      String companyCode = Get.find<AuthController>().userData!.companyCode;

      // JSON object that needs to be encoded
      Map<String, dynamic> selectParams = {
        "projectId": projectId,
        "reportType": "Job Card"
      };

      String encodedParams = Uri.encodeComponent(jsonEncode(selectParams));

      String apiUrl =
          "$getJobCardUrl?companyCode=$companyCode&selectParams=$encodedParams";

      print("Request URL: $apiUrl");

      var request = http.Request('GET', Uri.parse(apiUrl));

      http.StreamedResponse response = await request.send();

      // Check response status
      if (response.statusCode == 200) {
        final res = await response.stream.bytesToString();
        var responseData = json.decode(res);
        if (responseData["success"] == true) {
          /// Purchase details
          List<dynamic> purchaseAccounting =
              responseData["data"]["purchaseAccounting"] ?? [];

          if (purchaseAccounting.isNotEmpty) {
            for (var purchase in purchaseAccounting) {
              List<dynamic> details = purchase["details"] ?? [];

              overheadDirectInvoiceList.add(
                OverheadDirectInvoice(
                  orderRef: purchase["transactionNumber"].toString(),
                  date: purchase["date"].toString(),
                  supplierName: purchase["partyName"].toString(),
                  itemCode: details[0]["ledgerId"]["generalDetails"]
                          ["ledgerCode"]
                      .toString(),
                  description: details[0]["ledgerId"]["generalDetails"]
                          ["ledgerName"]
                      .toString(),
                  quantity: "1.00",
                  unitPrice:
                      fixAmountValues(details[0]["netAmount"].toString()),
                  budgetValue:
                      fixAmountValues(details[0]["netAmount"].toString()),
                  foreignOrder: "0.00",
                  orderAmt: fixAmountValues(details[0]["netAmount"].toString()),
                  amtSettled:
                      fixAmountValues(purchase["amountSettled"].toString()),
                  balance: fixAmountValues(purchase["balance"].toString()),
                ),
              );

              for (var detail in details.skip(1)) {
                overheadDirectInvoiceList.add(
                  OverheadDirectInvoice(
                    orderRef: purchase["transactionNumber"].toString(),
                    date: purchase["date"].toString(),
                    supplierName: purchase["partyName"].toString(),
                    itemCode: detail["ledgerId"]["generalDetails"]["ledgerCode"]
                        .toString(),
                    description: detail["ledgerId"]["generalDetails"]
                            ["ledgerName"]
                        .toString(),
                    quantity: "1.00",
                    unitPrice: fixAmountValues(detail["netAmount"].toString()),
                    budgetValue:
                        fixAmountValues(detail["netAmount"].toString()),
                    foreignOrder: "0.00",
                    orderAmt: fixAmountValues(detail["netAmount"].toString()),
                    amtSettled:
                        fixAmountValues(purchase["amountSettled"].toString()),
                    balance: fixAmountValues(purchase["balance"].toString()),
                  ),
                );
              }
            }
            update();
          }
        }
      } else {
        final res = await response.stream.bytesToString();
        var responseData = json.decode(res);

        if (responseData["message"] == "session expired") {
          credentialController.logoutUser();
          showToast("Session expired");
        }
        print("Error: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (e) {
      print(e.toString());
    } finally {
      updateJobLoader(false);
    }
  }

//////////////
  Future<void> fetchOverheadAgainstDirectPV(String projectId) async {
    updateJobLoader(true);
    try {
      String companyCode = Get.find<AuthController>().userData!.companyCode;

      // JSON object that needs to be encoded
      Map<String, dynamic> selectParams = {
        "projectId": projectId,
        "reportType": "Job Card"
      };

      String encodedParams = Uri.encodeComponent(jsonEncode(selectParams));

      String apiUrl =
          "$getJobCardUrl?companyCode=$companyCode&selectParams=$encodedParams";

      print("Request URL: $apiUrl");

      var request = http.Request('GET', Uri.parse(apiUrl));

      http.StreamedResponse response = await request.send();

      // Check response status
      if (response.statusCode == 200) {
        final res = await response.stream.bytesToString();
        var responseData = json.decode(res);
        if (responseData["success"] == true) {
          /// Purchase details
          List<dynamic> projectPayments =
              responseData["data"]["projectPayments"]["data"] ?? [];

          if (projectPayments.isNotEmpty) {
            for (var project in projectPayments) {
              List<dynamic> details = project["details"] ?? [];

              if (details.isNotEmpty && details.length.isGreaterThan(2)) {
                overheadAgainstDirectPVList.add(
                  OverheadAgainstDirectPV(
                    voucherNo: project["transactionNumber"].toString(),
                    date: project["date"] ?? "",
                    supplierName: "-",
                    overheadCode: details[1]["overheadName"].toString(),
                    description: details[0]["ledger"]["generalDetails"]
                            ["ledgerName"] ??
                        "",
                    estAmt: fixAmountValues(details[1]["amount"].toString()),
                    amtSettled:
                        fixAmountValues(details[1]["amount"].toString()),
                    balance: "0.00",
                    total: fixAmountValues(responseData["data"]
                            ["projectPayments"]["totalAmount"]
                        .toString()),
                    totalWithVA: fixAmountValues(responseData["data"]
                            ["projectPayments"]["totalAmount"]
                        .toString()),
                  ),
                );
              }
            }
            update();
          }
        }
      } else {
        final res = await response.stream.bytesToString();
        var responseData = json.decode(res);

        if (responseData["message"] == "session expired") {
          credentialController.logoutUser();
          showToast("Session expired");
        }
        print("Error: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (e) {
      print(e.toString());
    } finally {
      updateJobLoader(false);
    }
  }

//////////////
  Future<void> fetchJournalVoucher(String projectId) async {
    try {
      String companyCode = Get.find<AuthController>().userData!.companyCode;

      // JSON object that needs to be encoded
      Map<String, dynamic> selectParams = {
        "projectId": projectId,
        "reportType": "Job Card"
      };

      String encodedParams = Uri.encodeComponent(jsonEncode(selectParams));

      String apiUrl =
          "$getJobCardUrl?companyCode=$companyCode&selectParams=$encodedParams";

      print("Request URL: $apiUrl");

      var request = http.Request('GET', Uri.parse(apiUrl));

      http.StreamedResponse response = await request.send();

      // Check response status
      if (response.statusCode == 200) {
        final res = await response.stream.bytesToString();
        var responseData = json.decode(res);
        if (responseData["success"] == true) {
          /// Purchase details
          List<dynamic> journalVouchers =
              responseData["data"]["journalVouchers"] ?? [];

          if (journalVouchers.isNotEmpty) {
            for (var journal in journalVouchers) {
              List<dynamic> expenses = journal["onlyExpenses"] ?? [];

              if (expenses.isNotEmpty) {
                journalVoucherList.add(
                  JournalVoucher(
                    voucherNo: journal["transactionNumber"].toString(),
                    date: journal["date"].toString(),
                    supplierName: expenses[0]["overheadName"].toString(),
                    overheadCode: expenses[0]["ledger"]["generalDetails"]
                            ["ledgerName"] ??
                        "",
                    description: "",
                    debit: fixAmountValues(
                        expenses[0]["debitExAmount"].toString()),
                    credit: fixAmountValues(
                        expenses[0]["creditExAmount"].toString()),
                    balance: "0.00",
                  ),
                );

                for (var expense in expenses.skip(1)) {
                  JournalVoucher(
                    voucherNo: journal["transactionNumber"].toString(),
                    date: journal["date"].toString(),
                    supplierName: expense["overheadName"].toString(),
                    overheadCode:
                        expense["ledger"]["generalDetails"]["ledgerName"] ?? "",
                    description: "",
                    debit: fixAmountValues(expense["debitExAmount"].toString()),
                    credit:
                        fixAmountValues(expense["creditExAmount"].toString()),
                    balance: "0.00",
                  );
                }
              }
            }
            update();
          }
        }
      } else {
        final res = await response.stream.bytesToString();
        var responseData = json.decode(res);

        if (responseData["message"] == "session expired") {
          credentialController.logoutUser();
          showToast("Session expired");
        }
        print("Error: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (e) {
      print(e.toString());
    }
  }

///////
///////
///////
// Future<File> generatePdfFromTaskModel(
//       ProjectDetailsModel projectDetails,
//       ProjectEstimationModel estimation,
//       SalesCollectionModel salesCollection,
//       PurchaseCollectionModel purchaseCollection) async {
//     final pdf = pw.Document();

//     // Helper function for generating table-like rows with borders
//     pw.Widget buildRow(String label, String value) {
//       return pw.Row(
//         children: [
//           pw.Container(
//             width: 150,
//             padding: const pw.EdgeInsets.all(5),
//             decoration: pw.BoxDecoration(
//               border: pw.Border.all(color: PdfColors.black),
//               color: PdfColors.grey200,
//             ),
//             child: pw.Text(label,
//                 style: pw.TextStyle(
//                     fontWeight: pw.FontWeight.bold, fontSize: 14)),
//           ),
//           pw.Expanded(
//             child: pw.Container(
//               padding: const pw.EdgeInsets.all(5),
//               decoration: pw.BoxDecoration(
//                 border: pw.Border.all(color: PdfColors.black),
//               ),
//               child: pw.Text(value, style: pw.TextStyle(fontSize: 14)),
//             ),
//           ),
//         ],
//       );
//     }

//     pdf.addPage(
//       pw.Page(
//         pageFormat: PdfPageFormat.a4,
//         build: (pw.Context context) {
//           return pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: [
//               // Title
//               pw.Text("Task Estimation Report",
//                   style: pw.TextStyle(
//                       fontSize: 24,
//                       fontWeight: pw.FontWeight.bold,
//                       color: PdfColors.blue)),
//               pw.SizedBox(height: 10),
//               pw.Divider(),
//               pw.SizedBox(height: 20),

//               // Project Details
//               pw.Text("Project Details",
//                   style: pw.TextStyle(
//                       fontSize: 18, fontWeight: pw.FontWeight.bold)),
//               pw.SizedBox(height: 10),
//               ...projectDetailsEntries.map((entry) =>
//                   buildRow(entry.key, entry.value)),
//               pw.SizedBox(height: 20),

//               // Project Estimation
//               pw.Text("Project Estimation",
//                   style: pw.TextStyle(
//                       fontSize: 18, fontWeight: pw.FontWeight.bold)),
//               pw.SizedBox(height: 10),
//               ...estimationEntries.map((entry) =>
//                   buildRow(entry.key, entry.value)),
//               pw.SizedBox(height: 20),

//               // Sales Collection
//               pw.Text("Sales Collection",
//                   style: pw.TextStyle(
//                       fontSize: 18, fontWeight: pw.FontWeight.bold)),
//               pw.SizedBox(height: 10),
//               ...salesCollectionEntries.map((entry) =>
//                   buildRow(entry.key, entry.value)),
//               pw.SizedBox(height: 20),

//               // Purchase Collection
//               pw.Text("Purchase Collection",
//                   style: pw.TextStyle(
//                       fontSize: 18, fontWeight: pw.FontWeight.bold)),
//               pw.SizedBox(height: 10),
//               ...purchaseCollectionEntries.map((entry) =>
//                   buildRow(entry.key, entry.value)),
//               pw.SizedBox(height: 20),
//             ],
//           );
//         },
//       ),
//     );

//     final directory = await getApplicationDocumentsDirectory();
//     final file = File("${directory.path}/task_estimation_report.pdf");

//     await file.writeAsBytes(await pdf.save());

//     // Open the file
//     await OpenFile.open(file.path);

//     return file;
//   }
}

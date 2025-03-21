///// Task details model

class TaskDetailModel {
 TaskDetailModel({
    required this.taskId,
     required this.projectId,
    required this.taskName,
    required this.taskDate,
    required this.docType,
    required this.project,
    required this.projectDescription,
    required this.currentStatus,
    required this.status,
    required this.receiverId,
    required this.amount,
    required this.currency,
    required this.docNumber,
    required this.stakeholderName,
    required this.estimationId,
    required this.inQueue,
  });

  final String taskId;
  final String projectId;
  final String taskName;
  final String taskDate;
  final String stakeholderName;
  final String docType;
  final String estimationId;
  final String project;
  final String projectDescription;
  final String docNumber;
  final String amount;
  final String currency;
  final String inQueue;
   String currentStatus;
   final List<String> status;
   final List<String> receiverId;
  
}

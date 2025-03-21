



///// Activity model 

class ActivityModel {
  const ActivityModel({
    required this.user,
    required this.action,
    required this.status,
    required this.date,
    required this.remarks,
    required this.taskName,
  });

  final String user;
  final String action;
  final String status;
  final String date;
  final String remarks;
  final String taskName;
}

class RemarkModel {
  const RemarkModel({
    required this.user,
    required this.remarks,
  });

  final String user;
  final String remarks;
}

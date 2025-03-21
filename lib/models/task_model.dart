
class TaskModel {
  bool? success;
  int? code;
  String? message;
  Data? data;

  TaskModel({this.success, this.code, this.message, this.data});

  TaskModel.fromJson(Map<String, dynamic> json) {
    if(json["success"] is bool) {
      success = json["success"];
    }
    if(json["code"] is int) {
      code = json["code"];
    }
    if(json["message"] is String) {
      message = json["message"];
    }
    if(json["data"] is Map) {
      data = json["data"] == null ? null : Data.fromJson(json["data"]);
    }
  }

  static List<TaskModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(TaskModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["success"] = success;
    _data["code"] = code;
    _data["message"] = message;
    if(data != null) {
      _data["data"] = data?.toJson();
    }
    return _data;
  }
}

class Data {
  List<AllTask>? allTask;
  List<Pending>? pending;
  List<Rejected>? rejected;
  List<Approved>? approved;
  List<Completed>? completed;
  int? allTaskCount;
  int? pendingTaskCount;
  int? rejectedTaskCount;
  int? approvedTaskCount;
  int? completedTaskCount;

  Data({this.allTask, this.pending, this.rejected, this.approved, this.completed, this.allTaskCount, this.pendingTaskCount, this.rejectedTaskCount, this.approvedTaskCount, this.completedTaskCount});

  Data.fromJson(Map<String, dynamic> json) {
    if(json["allTask"] is List) {
      allTask = json["allTask"] == null ? null : (json["allTask"] as List).map((e) => AllTask.fromJson(e)).toList();
    }
    if(json["pending"] is List) {
      pending = json["pending"] == null ? null : (json["pending"] as List).map((e) => Pending.fromJson(e)).toList();
    }
    if(json["rejected"] is List) {
      rejected = json["rejected"] == null ? null : (json["rejected"] as List).map((e) => Rejected.fromJson(e)).toList();
    }
    if(json["approved"] is List) {
      approved = json["approved"] == null ? null : (json["approved"] as List).map((e) => Approved.fromJson(e)).toList();
    }
    if(json["completed"] is List) {
      completed = json["completed"] == null ? null : (json["completed"] as List).map((e) => Completed.fromJson(e)).toList();
    }
    if(json["allTaskCount"] is int) {
      allTaskCount = json["allTaskCount"];
    }
    if(json["PendingTaskCount"] is int) {
      pendingTaskCount = json["PendingTaskCount"];
    }
    if(json["rejectedTaskCount"] is int) {
      rejectedTaskCount = json["rejectedTaskCount"];
    }
    if(json["approvedTaskCount"] is int) {
      approvedTaskCount = json["approvedTaskCount"];
    }
    if(json["completedTaskCount"] is int) {
      completedTaskCount = json["completedTaskCount"];
    }
  }

  static List<Data> fromList(List<Map<String, dynamic>> list) {
    return list.map(Data.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if(allTask != null) {
      _data["allTask"] = allTask?.map((e) => e.toJson()).toList();
    }
    if(pending != null) {
      _data["pending"] = pending?.map((e) => e.toJson()).toList();
    }
    if(rejected != null) {
      _data["rejected"] = rejected?.map((e) => e.toJson()).toList();
    }
    if(approved != null) {
      _data["approved"] = approved?.map((e) => e.toJson()).toList();
    }
    if(completed != null) {
      _data["completed"] = completed?.map((e) => e.toJson()).toList();
    }
    _data["allTaskCount"] = allTaskCount;
    _data["PendingTaskCount"] = pendingTaskCount;
    _data["rejectedTaskCount"] = rejectedTaskCount;
    _data["approvedTaskCount"] = approvedTaskCount;
    _data["completedTaskCount"] = completedTaskCount;
    return _data;
  }
}

class Completed {
  String? id;
  String? created;
  String? type;
  String? stackHolderName;
  String? docNo;
  String? name;
  String? documentType;
  String? projectCode;
  String? projectName;
  String? projectDescription;
  String? remarks;
  String? projectId;
  String? estimationId;
  double? amount;
  String? status;
  dynamic narration;
  String? currentStatus;

  Completed({this.id, this.created, this.type, this.stackHolderName, this.docNo, this.name, this.documentType, this.projectCode, this.projectName, this.projectDescription, this.remarks, this.projectId, this.estimationId, this.amount, this.status, this.narration, this.currentStatus});

  Completed.fromJson(Map<String, dynamic> json) {
    if(json["_id"] is String) {
      id = json["_id"];
    }
    if(json["created"] is String) {
      created = json["created"];
    }
    if(json["type"] is String) {
      type = json["type"];
    }
    if(json["stackHolderName"] is String) {
      stackHolderName = json["stackHolderName"];
    }
    if(json["docNo"] is String) {
      docNo = json["docNo"];
    }
    if(json["name"] is String) {
      name = json["name"];
    }
    if(json["documentType"] is String) {
      documentType = json["documentType"];
    }
    if(json["projectCode"] is String) {
      projectCode = json["projectCode"];
    }
    if(json["projectName"] is String) {
      projectName = json["projectName"];
    }
    if(json["projectDescription"] is String) {
      projectDescription = json["projectDescription"];
    }
    if(json["remarks"] is String) {
      remarks = json["remarks"];
    }
    if(json["projectId"] is String) {
      projectId = json["projectId"];
    }
    if(json["estimationId"] is String) {
      estimationId = json["estimationId"];
    }
    if(json["amount"] is double) {
      amount = json["amount"];
    }
    if(json["status"] is String) {
      status = json["status"];
    }
    narration = json["narration"];
    if(json["currentStatus"] is String) {
      currentStatus = json["currentStatus"];
    }
  }

  static List<Completed> fromList(List<Map<String, dynamic>> list) {
    return list.map(Completed.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["_id"] = id;
    _data["created"] = created;
    _data["type"] = type;
    _data["stackHolderName"] = stackHolderName;
    _data["docNo"] = docNo;
    _data["name"] = name;
    _data["documentType"] = documentType;
    _data["projectCode"] = projectCode;
    _data["projectName"] = projectName;
    _data["projectDescription"] = projectDescription;
    _data["remarks"] = remarks;
    _data["projectId"] = projectId;
    _data["estimationId"] = estimationId;
    _data["amount"] = amount;
    _data["status"] = status;
    _data["narration"] = narration;
    _data["currentStatus"] = currentStatus;
    return _data;
  }
}

class Approved {
  String? id;
  String? created;
  String? type;
  String? stackHolderName;
  String? docNo;
  String? name;
  String? documentType;
  String? projectCode;
  String? projectName;
  String? projectDescription;
  String? remarks;
  String? projectId;
  String? estimationId;
  double? amount;
  String? status;
  dynamic narration;
  String? currentStatus;

  Approved({this.id, this.created, this.type, this.stackHolderName, this.docNo, this.name, this.documentType, this.projectCode, this.projectName, this.projectDescription, this.remarks, this.projectId, this.estimationId, this.amount, this.status, this.narration, this.currentStatus});

  Approved.fromJson(Map<String, dynamic> json) {
    if(json["_id"] is String) {
      id = json["_id"];
    }
    if(json["created"] is String) {
      created = json["created"];
    }
    if(json["type"] is String) {
      type = json["type"];
    }
    if(json["stackHolderName"] is String) {
      stackHolderName = json["stackHolderName"];
    }
    if(json["docNo"] is String) {
      docNo = json["docNo"];
    }
    if(json["name"] is String) {
      name = json["name"];
    }
    if(json["documentType"] is String) {
      documentType = json["documentType"];
    }
    if(json["projectCode"] is String) {
      projectCode = json["projectCode"];
    }
    if(json["projectName"] is String) {
      projectName = json["projectName"];
    }
    if(json["projectDescription"] is String) {
      projectDescription = json["projectDescription"];
    }
    if(json["remarks"] is String) {
      remarks = json["remarks"];
    }
    if(json["projectId"] is String) {
      projectId = json["projectId"];
    }
    if(json["estimationId"] is String) {
      estimationId = json["estimationId"];
    }
    if(json["amount"] is double) {
      amount = json["amount"];
    }
    if(json["status"] is String) {
      status = json["status"];
    }
    narration = json["narration"];
    if(json["currentStatus"] is String) {
      currentStatus = json["currentStatus"];
    }
  }

  static List<Approved> fromList(List<Map<String, dynamic>> list) {
    return list.map(Approved.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["_id"] = id;
    _data["created"] = created;
    _data["type"] = type;
    _data["stackHolderName"] = stackHolderName;
    _data["docNo"] = docNo;
    _data["name"] = name;
    _data["documentType"] = documentType;
    _data["projectCode"] = projectCode;
    _data["projectName"] = projectName;
    _data["projectDescription"] = projectDescription;
    _data["remarks"] = remarks;
    _data["projectId"] = projectId;
    _data["estimationId"] = estimationId;
    _data["amount"] = amount;
    _data["status"] = status;
    _data["narration"] = narration;
    _data["currentStatus"] = currentStatus;
    return _data;
  }
}

class Rejected {
  String? id;
  String? created;
  String? type;
  String? stackHolderName;
  String? docNo;
  String? name;
  String? documentType;
  String? projectCode;
  String? projectName;
  String? projectDescription;
  String? remarks;
  String? projectId;
  String? estimationId;
  double? amount;
  String? status;
  dynamic narration;
  String? currentStatus;

  Rejected({this.id, this.created, this.type, this.stackHolderName, this.docNo, this.name, this.documentType, this.projectCode, this.projectName, this.projectDescription, this.remarks, this.projectId, this.estimationId, this.amount, this.status, this.narration, this.currentStatus});

  Rejected.fromJson(Map<String, dynamic> json) {
    if(json["_id"] is String) {
      id = json["_id"];
    }
    if(json["created"] is String) {
      created = json["created"];
    }
    if(json["type"] is String) {
      type = json["type"];
    }
    if(json["stackHolderName"] is String) {
      stackHolderName = json["stackHolderName"];
    }
    if(json["docNo"] is String) {
      docNo = json["docNo"];
    }
    if(json["name"] is String) {
      name = json["name"];
    }
    if(json["documentType"] is String) {
      documentType = json["documentType"];
    }
    if(json["projectCode"] is String) {
      projectCode = json["projectCode"];
    }
    if(json["projectName"] is String) {
      projectName = json["projectName"];
    }
    if(json["projectDescription"] is String) {
      projectDescription = json["projectDescription"];
    }
    if(json["remarks"] is String) {
      remarks = json["remarks"];
    }
    if(json["projectId"] is String) {
      projectId = json["projectId"];
    }
    if(json["estimationId"] is String) {
      estimationId = json["estimationId"];
    }
    if(json["amount"] is double) {
      amount = json["amount"];
    }
    if(json["status"] is String) {
      status = json["status"];
    }
    narration = json["narration"];
    if(json["currentStatus"] is String) {
      currentStatus = json["currentStatus"];
    }
  }

  static List<Rejected> fromList(List<Map<String, dynamic>> list) {
    return list.map(Rejected.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["_id"] = id;
    _data["created"] = created;
    _data["type"] = type;
    _data["stackHolderName"] = stackHolderName;
    _data["docNo"] = docNo;
    _data["name"] = name;
    _data["documentType"] = documentType;
    _data["projectCode"] = projectCode;
    _data["projectName"] = projectName;
    _data["projectDescription"] = projectDescription;
    _data["remarks"] = remarks;
    _data["projectId"] = projectId;
    _data["estimationId"] = estimationId;
    _data["amount"] = amount;
    _data["status"] = status;
    _data["narration"] = narration;
    _data["currentStatus"] = currentStatus;
    return _data;
  }
}

class Pending {
  String? id;
  String? created;
  String? type;
  String? stackHolderName;
  String? docNo;
  String? name;
  String? documentType;
  String? projectCode;
  String? projectName;
  String? projectDescription;
  String? remarks;
  String? projectId;
  String? estimationId;
  double? amount;
  String? status;
  dynamic narration;
  String? currentStatus;

  Pending({this.id, this.created, this.type, this.stackHolderName, this.docNo, this.name, this.documentType, this.projectCode, this.projectName, this.projectDescription, this.remarks, this.projectId, this.estimationId, this.amount, this.status, this.narration, this.currentStatus});

  Pending.fromJson(Map<String, dynamic> json) {
    if(json["_id"] is String) {
      id = json["_id"];
    }
    if(json["created"] is String) {
      created = json["created"];
    }
    if(json["type"] is String) {
      type = json["type"];
    }
    if(json["stackHolderName"] is String) {
      stackHolderName = json["stackHolderName"];
    }
    if(json["docNo"] is String) {
      docNo = json["docNo"];
    }
    if(json["name"] is String) {
      name = json["name"];
    }
    if(json["documentType"] is String) {
      documentType = json["documentType"];
    }
    if(json["projectCode"] is String) {
      projectCode = json["projectCode"];
    }
    if(json["projectName"] is String) {
      projectName = json["projectName"];
    }
    if(json["projectDescription"] is String) {
      projectDescription = json["projectDescription"];
    }
    if(json["remarks"] is String) {
      remarks = json["remarks"];
    }
    if(json["projectId"] is String) {
      projectId = json["projectId"];
    }
    if(json["estimationId"] is String) {
      estimationId = json["estimationId"];
    }
    if(json["amount"] is double) {
      amount = json["amount"];
    }
    if(json["status"] is String) {
      status = json["status"];
    }
    narration = json["narration"];
    if(json["currentStatus"] is String) {
      currentStatus = json["currentStatus"];
    }
  }

  static List<Pending> fromList(List<Map<String, dynamic>> list) {
    return list.map(Pending.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["_id"] = id;
    _data["created"] = created;
    _data["type"] = type;
    _data["stackHolderName"] = stackHolderName;
    _data["docNo"] = docNo;
    _data["name"] = name;
    _data["documentType"] = documentType;
    _data["projectCode"] = projectCode;
    _data["projectName"] = projectName;
    _data["projectDescription"] = projectDescription;
    _data["remarks"] = remarks;
    _data["projectId"] = projectId;
    _data["estimationId"] = estimationId;
    _data["amount"] = amount;
    _data["status"] = status;
    _data["narration"] = narration;
    _data["currentStatus"] = currentStatus;
    return _data;
  }
}

class AllTask {
  String? id;
  String? created;
  String? type;
  String? stackHolderName;
  String? docNo;
  String? name;
  String? documentType;
  String? projectCode;
  String? projectName;
  String? projectDescription;
  String? remarks;
  String? projectId;
  String? estimationId;
  double? amount;
  String? status;
  String? narration;
  String? currentStatus;

  AllTask({this.id, this.created, this.type, this.stackHolderName, this.docNo, this.name, this.documentType, this.projectCode, this.projectName, this.projectDescription, this.remarks, this.projectId, this.estimationId, this.amount, this.status, this.narration, this.currentStatus});

  AllTask.fromJson(Map<String, dynamic> json) {
    if(json["_id"] is String) {
      id = json["_id"];
    }
    if(json["created"] is String) {
      created = json["created"];
    }
    if(json["type"] is String) {
      type = json["type"];
    }
    if(json["stackHolderName"] is String) {
      stackHolderName = json["stackHolderName"];
    }
    if(json["docNo"] is String) {
      docNo = json["docNo"];
    }
    if(json["name"] is String) {
      name = json["name"];
    }
    if(json["documentType"] is String) {
      documentType = json["documentType"];
    }
    if(json["projectCode"] is String) {
      projectCode = json["projectCode"];
    }
    if(json["projectName"] is String) {
      projectName = json["projectName"];
    }
    if(json["projectDescription"] is String) {
      projectDescription = json["projectDescription"];
    }
    if(json["remarks"] is String) {
      remarks = json["remarks"];
    }
    if(json["projectId"] is String) {
      projectId = json["projectId"];
    }
    if(json["estimationId"] is String) {
      estimationId = json["estimationId"];
    }
    if(json["amount"] is double) {
      amount = json["amount"];
    }
    if(json["status"] is String) {
      status = json["status"];
    }
    if(json["narration"] is String) {
      narration = json["narration"];
    }
    if(json["currentStatus"] is String) {
      currentStatus = json["currentStatus"];
    }
  }

  static List<AllTask> fromList(List<Map<String, dynamic>> list) {
    return list.map(AllTask.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["_id"] = id;
    _data["created"] = created;
    _data["type"] = type;
    _data["stackHolderName"] = stackHolderName;
    _data["docNo"] = docNo;
    _data["name"] = name;
    _data["documentType"] = documentType;
    _data["projectCode"] = projectCode;
    _data["projectName"] = projectName;
    _data["projectDescription"] = projectDescription;
    _data["remarks"] = remarks;
    _data["projectId"] = projectId;
    _data["estimationId"] = estimationId;
    _data["amount"] = amount;
    _data["status"] = status;
    _data["narration"] = narration;
    _data["currentStatus"] = currentStatus;
    return _data;
  }
}
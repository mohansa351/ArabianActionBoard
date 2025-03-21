

///// Notification model 

class NotificationModel {
  const NotificationModel( {
    required this.title,
    required this.description,
    required this.status,
    required this.taskId,
    required this.senderName,
    required this.receiverId,
    required this.notificationDate,
    required this.senderId,
    required this.docType
  });

  final String title;
  final String description;
  final String status;
  final String taskId;
  final String senderName;
  final String receiverId;
  final String notificationDate;
  final String senderId;
  final String docType;
}





///// User details model


class UserModel {
  const UserModel({
    required this.id,
    required this.email,
    required this.userName,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.middleName,
    required this.companyName,
    required this.companyCode,
    required this.fcmToken,
  });

  final String id;
  final String email;
  final String userName;
  final String firstName;
  final String lastName;
  final String phone;
  final String middleName;
  final String companyName;
  final String companyCode;
  final String fcmToken;
}

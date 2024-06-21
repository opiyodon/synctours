class CustomUser {
  final String? uid;

  CustomUser({this.uid});
}

class UserData {
  final String? uid;
  final String fullname;
  final String username;
  final String? phoneNumber;

  UserData({
    this.uid,
    required this.fullname,
    required this.username,
    this.phoneNumber,
  });
}
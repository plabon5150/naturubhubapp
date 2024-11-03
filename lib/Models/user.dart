class User {
  int userID;
  String userName;
  String password;
  int empID;
  String fullName;

  User({
    required this.userID,
    required this.userName,
    required this.password,
    required this.empID,
    required this.fullName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userID: json['UserID'],
      userName: json['UserName'],
      password: json['Password'],
      empID: json['EmpID'],
      fullName: json['FullName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'UserID': userID,
      'UserName': userName,
      'Password': password,
      'EmpID': empID,
      'FullName': fullName
    };
  }
}

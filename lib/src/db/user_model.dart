class UserModel {
  String userName;
  String emailID;
  int id, mobileNo, password, role = 2;
  DateTime timestamp;

  UserModel(
      {this.userName, this.emailID, this.mobileNo, this.role, this.password});

  UserModel.fromDB(Map<String, dynamic> parsedJSON) {
    id = parsedJSON["id"];
    userName = parsedJSON["name"];
    emailID = parsedJSON["email"];
    mobileNo = parsedJSON["mobile"];
    role = parsedJSON["role"];
    password = parsedJSON["password"].hashCode;
    timestamp = DateTime.parse(parsedJSON["reg_date"]);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "name": userName,
      "email": emailID,
      "mobile": mobileNo,
      "password": password,
      "role": role
    };
  }
}

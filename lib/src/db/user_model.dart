class UserModel {
  String userName;
  String emailID;
  int password;

  UserModel({this.userName, this.emailID, this.password});

  UserModel.fromDB(Map<String, dynamic> parsedJSON) {
    userName = parsedJSON["userName"];
    emailID = parsedJSON["emailID"];
    password = parsedJSON["password"].hashCode;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "userName": userName,
      "emailID": emailID,
      "password": password,
    };
  }
}

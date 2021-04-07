// role_model.dart contains the model required to represent user's priviledge
// data or roles acquired from the database

class RoleModel {
  int id;
  String name;

  RoleModel({this.id, this.name});

  RoleModel.fromDB(Map<String, dynamic> parsedJSON) {
    id = parsedJSON["id"];
    name = parsedJSON["name"];
  }
}

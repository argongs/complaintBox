class RoleModel {
  int id;
  String name;

  RoleModel({this.id, this.name});

  RoleModel.fromDB(Map<String, dynamic> parsedJSON) {
    id = parsedJSON["id"];
    name = parsedJSON["name"];
  }
}

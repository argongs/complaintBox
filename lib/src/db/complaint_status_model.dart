class ComplaintStatusModel {
  int id;
  String name;

  ComplaintStatusModel({this.id, this.name});

  ComplaintStatusModel.fromDB(Map<String, dynamic> parsedJSON) {
    id = parsedJSON["id"];
    name = parsedJSON["name"];
  }
}

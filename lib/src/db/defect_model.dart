class DefectModel {
  int defectCode;
  String defectName;

  DefectModel({this.defectCode, this.defectName});

  DefectModel.fromDB(Map<String, dynamic> parsedJSON) {
    defectCode = parsedJSON["id"];
    defectName = parsedJSON["name"];
  }
}

class DefectSubtypeModel {
  int defectSubtypeCode, defectCode;
  String defectSubtypeName;

  DefectSubtypeModel(
      {this.defectCode, this.defectSubtypeCode, this.defectSubtypeName});

  DefectSubtypeModel.fromDB(Map<String, dynamic> parsedJSON) {
    defectSubtypeCode = parsedJSON["id"];
    defectCode = parsedJSON["defect_id"];
    defectSubtypeName = parsedJSON["name"];
  }
}

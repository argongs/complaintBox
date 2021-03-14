class SeverityModel {
  int severityCode;
  String severityName;

  SeverityModel({this.severityCode, this.severityName});

  SeverityModel.fromDB(Map<String, dynamic> parsedJSON) {
    severityCode = parsedJSON["severityCode"];
    severityName = parsedJSON["severityName"];
  }
}

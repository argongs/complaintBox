// severity_model.dart contains the model required to represent defect
// severity data acquired from the database

class SeverityModel {
  int severityCode;
  String severityName;

  SeverityModel({this.severityCode, this.severityName});

  SeverityModel.fromDB(Map<String, dynamic> parsedJSON) {
    severityCode = parsedJSON["severityCode"];
    severityName = parsedJSON["severityName"];
  }
}

class ComplaintModel {
  int timestamp;
  double latitude, longitude, locationAccuracy;
  String userName, imagePath, issue;
  int severity = 3, typeOfDefect = 1;
  double length, width;

  ComplaintModel(
      {this.timestamp,
      this.latitude,
      this.longitude,
      this.locationAccuracy,
      this.userName,
      this.imagePath,
      this.issue,
      this.severity,
      this.typeOfDefect,
      this.length,
      this.width});

  ComplaintModel.fromDB(Map<String, dynamic> parsedJSON) {
    timestamp = parsedJSON["timestamp"];
    latitude = parsedJSON["latitude"];
    longitude = parsedJSON["longitude"];
    locationAccuracy = parsedJSON["locationAccuracy"];
    userName = parsedJSON["userName"];
    imagePath = parsedJSON["imagePath"];
    issue = parsedJSON["issue"];
    severity = parsedJSON["severity"];
    typeOfDefect = parsedJSON["typeOfDefect"];
    length = parsedJSON["length"];
    width = parsedJSON["width"];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "timestamp": timestamp,
      "latitude": latitude,
      "longitude": longitude,
      "locationAccuracy": locationAccuracy,
      "userName": userName,
      "imagePath": imagePath,
      "issue": issue,
      "severity": severity,
      "typeOfDefect": typeOfDefect,
      "length": length,
      "width": width,
    };
  }

  static Map<String, int> severityMap = {"High": 1, "Medium": 2, "Low": 3};
  static Map<String, int> defectMap = {"Pothole": 1, "Crack": 2};
}

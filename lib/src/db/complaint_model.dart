class ComplaintModel {
  int timestamp;
  double latitude;
  double longitude;
  double locationAccuracy;
  String userName;
  String imagePath;
  String issue;

  ComplaintModel(
      {this.timestamp,
      this.latitude,
      this.longitude,
      this.locationAccuracy,
      this.userName,
      this.imagePath,
      this.issue});

  ComplaintModel.fromDB(Map<String, dynamic> parsedJSON) {
    timestamp = parsedJSON["timestamp"];
    latitude = parsedJSON["latitude"];
    longitude = parsedJSON["longitude"];
    locationAccuracy = parsedJSON["locationAccuracy"];
    userName = parsedJSON["userName"];
    imagePath = parsedJSON["imagePath"];
    issue = parsedJSON["issue"];
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
    };
  }
}

class ComplaintModel {
  int id, userID;
  DateTime timestamp;
  double latitude, longitude;
  String imagePath, description, shortDescription;
  int severity = 3, typeOfDefect = 1, defectSubtype = 1, status = 1;
  double length, width, depth;

  ComplaintModel(
      {this.userID,
      this.latitude,
      this.longitude,
      this.imagePath,
      this.description,
      this.shortDescription,
      this.severity,
      this.typeOfDefect,
      this.defectSubtype,
      this.length,
      this.width,
      this.depth,
      this.status});

  ComplaintModel.fromDB(Map<String, dynamic> parsedJSON) {
    id = parsedJSON["id"];
    userID = parsedJSON["user_id"];
    timestamp = DateTime.parse(parsedJSON["timestamp"]);
    latitude = parsedJSON["latitude"];
    longitude = parsedJSON["longitude"];
    imagePath = parsedJSON["img_name"];
    description = parsedJSON["description"];
    shortDescription = parsedJSON["short_description"];
    severity = parsedJSON["severity"];
    typeOfDefect = parsedJSON["defect_id"];
    defectSubtype = parsedJSON["subtype_id"];
    length = parsedJSON["length"];
    width = parsedJSON["width"];
    depth = parsedJSON["depth"];
    status = parsedJSON["status_id"];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "user_id": userID,
      "latitude": latitude,
      "longitude": longitude,
      "img_name": imagePath,
      "description": description,
      "short_description": shortDescription,
      "severity": severity,
      "defect_id": typeOfDefect,
      "subtype_id": defectSubtype,
      "length": length,
      "width": width,
      "depth": depth,
      "status_id": status
    };
  }
}

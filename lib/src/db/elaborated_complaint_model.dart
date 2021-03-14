class ElaboratedComplaintModel {
  DateTime timestamp;
  double latitude, longitude;
  String imagePath,
      description,
      shortDescription,
      severityName,
      defectName,
      defectSubtypeName,
      complaintStatus;
  double length, width, depth;

  ElaboratedComplaintModel(
      {this.timestamp,
      this.latitude,
      this.longitude,
      this.imagePath,
      this.description,
      this.shortDescription,
      this.severityName,
      this.defectName,
      this.defectSubtypeName,
      this.complaintStatus,
      this.length,
      this.width,
      this.depth});

  ElaboratedComplaintModel.fromDB(Map<String, dynamic> parsedJSON) {
    timestamp = DateTime.parse(parsedJSON["timestamp"]);
    latitude = parsedJSON["latitude"];
    longitude = parsedJSON["longitude"];
    imagePath = parsedJSON["img_name"];
    shortDescription = parsedJSON["short_description"];
    description = parsedJSON["description"];
    severityName = parsedJSON["severityName"];
    defectName = parsedJSON["name"];
    defectSubtypeName = parsedJSON["name:1"];
    complaintStatus = parsedJSON["name:2"];
    length = parsedJSON["length"];
    width = parsedJSON["width"];
    depth = parsedJSON["depth"];
  }
}

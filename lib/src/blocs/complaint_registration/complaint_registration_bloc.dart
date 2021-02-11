import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:location/location.dart';
import 'complaint_registration_validators.dart';
import '../../db/database_interface.dart';
import '../../db/complaint_model.dart';

class ComplaintRegistrationBloc with ComplaintRegistrationValidators {
  final _locationController = BehaviorSubject<List<double>>();
  final _imageController = BehaviorSubject<String>();
  final _issueController = BehaviorSubject<String>();
  final _severityController = BehaviorSubject<int>();
  final _defectController = BehaviorSubject<int>();
  final _lengthController = BehaviorSubject<double>();
  final _widthController = BehaviorSubject<double>();

  // To obtain stream of data from the registration form and perform validation
  Stream<List<double>> readLocation() =>
      _locationController.stream.transform(locationValidator);
  Stream<String> readImage() =>
      _imageController.stream.transform(imageValidator);
  Stream<String> readIssue() =>
      _issueController.stream.transform(issueValidator);
  Stream<int> readSeverity() => _severityController.stream;
  Stream<int> readDefect() => _defectController.stream;
  Stream<double> readLength() =>
      _lengthController.stream.transform(lengthValidator);
  Stream<double> readWidth() =>
      _widthController.stream.transform(widthValidator);

  // If all the fields have appropriate values, then only complaint registration
  // should be allowed
  Stream<bool> canRegister() => Rx.combineLatest7(
        readLocation(),
        readImage(),
        readIssue(),
        readSeverity(),
        readDefect(),
        readLength(),
        readWidth(),
        (location, image, issue, severity, defect, length, width) => true,
      );

  //To accomodate new changes in the registration form fields
  void changeLocation(List<double> newLocation) =>
      _locationController.sink.add(newLocation); //
  void changeImage(String newImage) => _imageController.sink.add(newImage);
  void changeIssue(String newIssue) => _issueController.sink.add(newIssue);
  void changeSeverity(int newSeverity) =>
      _severityController.sink.add(newSeverity);
  void changeDefect(int newDefect) => _defectController.sink.add(newDefect);
  void changeLength(String newLengthString) {
    _lengthController.sink.add(double.parse(newLengthString));
  }

  void changeWidth(String newWidthString) {
    _widthController.sink.add(double.parse(newWidthString));
  }

  Future<int> registerData(DatabaseInterface dbInteractor) async {
    final List<double> validLocation = _locationController.value;
    final String validImage = _imageController.value;
    final String validIssue = _issueController.value;
    final int validSeverity = _severityController.value;
    final int validDefect = _defectController.value;
    final double validLength = _lengthController.value;
    final double validWidth = _widthController.value;

    // Store the clicked image in the phone memory
    final int timestamp = DateTime.now().millisecondsSinceEpoch;
    final String loggedInUser = dbInteractor.getLoggedInUserName();

    final int insertionStatus = await dbInteractor.insertComplaint(
      ComplaintModel(
        timestamp: timestamp,
        latitude: validLocation[0],
        longitude: validLocation[1],
        locationAccuracy: validLocation[2],
        userName: loggedInUser,
        issue: validIssue,
        imagePath: validImage,
        severity: validSeverity,
        typeOfDefect: validDefect,
        length: validLength,
        width: validWidth,
      ),
    );

    return insertionStatus;
  }

  void obtainLocation() async {
    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();

    final List<double> summarisedLocation = <double>[
      _locationData.latitude,
      _locationData.longitude,
      _locationData.accuracy
    ];

    changeLocation(summarisedLocation);
  }

  void dispose() {
    _locationController.close();
    _imageController.close();
    _issueController.close();
    _severityController.close();
    _defectController.close();
    _lengthController.close();
    _widthController.close();
  }
}

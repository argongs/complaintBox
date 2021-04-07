// complaint_registration_bloc.dart holds the code for the backend of the
// complaint registration form

import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:location/location.dart';
import 'complaint_registration_validators.dart';
import '../../db/database_interface.dart';
import '../../db/models/complaint_model.dart';
import '../../db/models/user_model.dart';

class ComplaintRegistrationBloc with ComplaintRegistrationValidators {
  final _locationController = BehaviorSubject<List<double>>();
  final _imageController = BehaviorSubject<String>();
  final _descriptionController = BehaviorSubject<String>();
  final _shortDescriptionController = BehaviorSubject<String>();
  final _severityController = BehaviorSubject<int>();
  final _defectController = BehaviorSubject<int>();
  final _defectSubtypeController = BehaviorSubject<int>();
  final _lengthController = BehaviorSubject<double>();
  final _widthController = BehaviorSubject<double>();
  final _depthController = BehaviorSubject<double>();

  // To obtain stream of data from the registration form and perform validation
  Stream<List<double>> readLocation() =>
      _locationController.stream.transform(locationValidator);
  Stream<String> readImage() =>
      _imageController.stream.transform(imageValidator);
  Stream<String> readDescription() =>
      _descriptionController.stream.transform(descriptionValidator);
  Stream<String> readShortDescription() =>
      _shortDescriptionController.stream.transform(descriptionValidator);
  Stream<int> readSeverity() => _severityController.stream;
  Stream<int> readDefect() => _defectController.stream;
  Stream<int> readDefectSubtype() => _defectSubtypeController.stream;
  Stream<double> readLength() =>
      _lengthController.stream.transform(lengthValidator);
  Stream<double> readWidth() =>
      _widthController.stream.transform(lengthValidator);
  Stream<double> readDepth() =>
      _depthController.stream.transform(lengthValidator);

  // If all the fields have appropriate values, then only complaint registration
  // should be allowed
  Stream<bool> canRegister() => Rx.combineLatest(
        <Stream>[
          readLocation(),
          readImage(),
          readDescription(),
          readShortDescription(),
          readSeverity(),
          readDefect(),
          readDefectSubtype(),
          readLength(),
          readWidth(),
          readDepth()
        ],
        ([
          location,
          image,
          description,
          shortDescription,
          severity,
          defect,
          defectSubtype,
          length,
          width,
          depth,
        ]) =>
            true,
      );

  //To accomodate new changes in the registration form fields
  void changeLocation(List<double> newLocation) =>
      _locationController.sink.add(newLocation); //
  void changeImage(String newImage) => _imageController.sink.add(newImage);
  void changeDescription(String newDescription) =>
      _descriptionController.sink.add(newDescription);
  void changeShortDescription(String newShortDescription) =>
      _shortDescriptionController.sink.add(newShortDescription);
  void changeSeverity(int newSeverity) =>
      _severityController.sink.add(newSeverity);
  void changeDefect(int newDefect) => _defectController.sink.add(newDefect);
  void changeDefectSubtype(int newDefectSubtype) =>
      _defectSubtypeController.sink.add(newDefectSubtype);

  void changeLength(String newLengthString) {
    _lengthController.sink.add(double.parse(newLengthString));
  }

  void changeWidth(String newWidthString) {
    _widthController.sink.add(double.parse(newWidthString));
  }

  void changeDepth(String newDepthString) {
    _depthController.sink.add(double.parse(newDepthString));
  }

  Future<int> registerData(
      DatabaseInterface dbInteractor, int complaintID) async {
    final List<double> validLocation = _locationController.value;
    final String validImage = _imageController.value;
    final String validDescription = _descriptionController.value;
    final String validShortDescription = _shortDescriptionController.value;
    final int validSeverity = _severityController.value;
    final int validDefect = _defectController.value;
    final int validDefectSubtype = _defectSubtypeController.value;
    final double validLength = _lengthController.value;
    final double validWidth = _widthController.value;
    final double validDepth = _depthController.value;

    // Store the clicked image in the phone memory
    final UserModel loggedInUserData = dbInteractor.getLoggedInUserData();
    int queryStatus;

    if (complaintID == 0)
      queryStatus = await dbInteractor.insertComplaint(
        ComplaintModel(
          userID: loggedInUserData.id,
          latitude: validLocation[0],
          longitude: validLocation[1],
          imagePath: validImage,
          description: validDescription,
          shortDescription: validShortDescription,
          severity: validSeverity,
          typeOfDefect: validDefect,
          defectSubtype: validDefectSubtype,
          length: validLength,
          width: validWidth,
          depth: validDepth,
          status: 0,
        ),
      );
    else
      queryStatus = await dbInteractor.updateComplaint(
        complaintID,
        ComplaintModel(
          userID: loggedInUserData.id,
          latitude: validLocation[0],
          longitude: validLocation[1],
          imagePath: validImage,
          description: validDescription,
          shortDescription: validShortDescription,
          severity: validSeverity,
          typeOfDefect: validDefect,
          defectSubtype: validDefectSubtype,
          length: validLength,
          width: validWidth,
          depth: validDepth,
          status: 0,
        ),
      );

    return queryStatus;
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
    _descriptionController.close();
    _shortDescriptionController.close();
    _severityController.close();
    _defectController.close();
    _defectSubtypeController.close();
    _lengthController.close();
    _widthController.close();
    _depthController.close();
  }
}

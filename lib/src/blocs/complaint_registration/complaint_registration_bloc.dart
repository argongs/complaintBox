import 'dart:async';
import 'dart:io';
import 'package:rxdart/rxdart.dart';
import 'package:location/location.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;
import 'complaint_registration_validators.dart';
import '../../db/database_interface.dart';
import '../../db/complaint_model.dart';

class ComplaintRegistrationBloc with ComplaintRegistrationValidators {
  final _locationController = BehaviorSubject<List<double>>();
  final _imageController = BehaviorSubject<String>();
  final _issueController = BehaviorSubject<String>();

  // To obtain stream of data from the registration form and perform validation
  Stream<List<double>> readLocation() =>
      _locationController.stream.transform(locationValidator);
  Stream<String> readImage() =>
      _imageController.stream.transform(imageValidator);
  Stream<String> readIssue() =>
      _issueController.stream.transform(issueValidator);
  // If all the fields have appropriate values, then only complaint registration
  // should be allowed
  Stream<bool> canRegister() => Rx.combineLatest3(readLocation(), readImage(),
      readIssue(), (location, image, issue) => true);

  //To accomodate new changes in the registration form fields
  void changeLocation(List<double> newLocation) =>
      _locationController.sink.add(newLocation); //
  void changeImage(String newImage) => _imageController.sink.add(newImage);
  void changeIssue(String newIssue) => _issueController.sink.add(newIssue);

  Future<int> registerData(DatabaseInterface dbInteractor) async {
    final List<double> validLocation = _locationController.value;
    final String validImage = _imageController.value;
    final String validIssue = _issueController.value;
    final int insertionStatus = await dbInteractor.insertComplaint(
        ComplaintModel(
            timestamp: DateTime.now().millisecondsSinceEpoch,
            latitude: validLocation[0],
            longitude: validLocation[1],
            locationAccuracy: validLocation[2],
            userName: dbInteractor.getLoggedInUserName(),
            issue: validIssue,
            imagePath: validImage));

    return insertionStatus;
    // if (insertionStatus > 0)
    //   print("Complaint is now registered.");
    // else
    //   print("Failed to perform complaint registration");
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
  }
}

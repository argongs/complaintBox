// admin_bloc.dart contains the backend logic for the things that are seen
// by the admin

import 'dart:async';
//import 'package:googleapis/drive/v3.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AdminBloc {
  final StreamController<int> _tableController =
      StreamController<int>.broadcast();
  final StreamController<int> _userTableSubtypeController =
      StreamController<int>.broadcast();
  final StreamController<int> _complaintTableSubtypeController =
      StreamController<int>.broadcast();
  final StreamController _googleAccountController =
      StreamController.broadcast();

  void changeTable(int newTable) => _tableController.sink.add(newTable);
  void changeUserTableSubtype(int newUserTableSubtype) =>
      _userTableSubtypeController.sink.add(newUserTableSubtype);
  void changeComplaintTableSubtype(int newComplaintTableSubtype) =>
      _complaintTableSubtypeController.sink.add(newComplaintTableSubtype);

  Future<void> changeGoogleAccount() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ["drive", "https://www.googleapis.com/auth/drive"]);

    try {
      await googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Stream<int> readTableName() => _tableController.stream;
  Stream<int> readUserTableSubtype() => _userTableSubtypeController.stream;
  Stream<int> readComplaintTableSubtype() =>
      _complaintTableSubtypeController.stream;

  void dispose() {
    _tableController.close();
    _userTableSubtypeController.close();
    _complaintTableSubtypeController.close();
    _googleAccountController.close();
  }
}

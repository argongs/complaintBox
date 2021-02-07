import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'login_validators.dart';
import '../../db/database_interface.dart';

class LoginBloc with LoginValidators {
  final _userNameController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  // Obtain the streams (after the contents of the streams are validated)
  Stream<String> readUserName() =>
      _userNameController.stream.transform(userNameValidator);
  Stream<String> readPassword() =>
      _passwordController.stream.transform(passwordValidator);
  Stream<bool> canSubmit() => Rx.combineLatest2(
        readUserName(),
        readPassword(),
        (userName, password) => true,
      );

  // Change user name and password
  void changeUserName(String newUserName) =>
      _userNameController.sink.add(newUserName);
  void changePassword(String newPassword) =>
      _passwordController.sink.add(newPassword);

  Future<int> submitData(DatabaseInterface dbInteractor) async {
    final String validUserName = _userNameController.value;
    final String validPassword = _passwordController.value;
    final dbData = await dbInteractor.obtainUser(validUserName, validPassword);

    if (dbData == null) {
      print("Invalid user name or password");
      return 1;
    } else {
      dbInteractor.updateLoggedInUserName(validUserName);
      print("$validUserName is online now.");
      return 0;
    }
  }

  // Close up the streams
  void dispose() {
    _userNameController.close();
    _passwordController.close();
  }
}

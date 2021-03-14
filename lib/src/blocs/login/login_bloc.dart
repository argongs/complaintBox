import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'login_validators.dart';
import '../../db/database_interface.dart';

class LoginBloc with LoginValidators {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  // Obtain the streams (after the contents of the streams are validated)
  Stream<String> readEmail() =>
      _emailController.stream.transform(emailValidator);
  Stream<String> readPassword() =>
      _passwordController.stream.transform(passwordValidator);
  Stream<bool> canSubmit() => Rx.combineLatest2(
        readEmail(),
        readPassword(),
        (email, password) => true,
      );

  // Change user name and password
  void changeEmail(String newEmail) => _emailController.sink.add(newEmail);
  void changePassword(String newPassword) =>
      _passwordController.sink.add(newPassword);

  Future<int> submitData(DatabaseInterface dbInteractor) async {
    final String validEmail = _emailController.value;
    final String validPassword = _passwordController.value;
    final dbData = await dbInteractor.obtainUser(validEmail, validPassword);

    if (dbData == null) {
      print("Invalid email or password");
      return 1;
    } else {
      print("$validEmail is online now.");
      return 0;
    }
  }

  // Close up the streams
  void dispose() {
    _emailController.close();
    _passwordController.close();
  }
}

import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'registration_validators.dart';
import '../../db/database_interface.dart';
import '../../db/user_model.dart';

class RegistrationBloc with RegistrationValidators {
  final _userNameController = BehaviorSubject<String>();
  final _emailController = BehaviorSubject<String>();
  final _mobileNoController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _confirmPasswordController = BehaviorSubject<String>();

  // To obtain stream of data from the registration form and perform validation
  Stream<String> readUserName() =>
      _userNameController.stream.transform(userNameValidator);
  Stream<String> readEmail() =>
      _emailController.stream.transform(emailValidator);
  Stream<String> readMobileNo() =>
      _mobileNoController.stream.transform(mobileNoValidator);
  Stream<String> readPassword() =>
      _passwordController.stream.transform(passwordValidator);
  // Here we can merge the streams from 'password' and 'confirm password' fields
  // into a list so that the transformer can be compare the 2 and generate error
  // accordingly
  Stream<String> readConfirmPassword() => Rx.combineLatest2(
          _confirmPasswordController.stream,
          readPassword(),
          (password, confirmPassword) => <String>[password, confirmPassword])
      .transform(confirmPasswordValidator);
  // If all the fields have appropriate values, then only registration
  // should be allowed
  Stream<bool> canRegister() => Rx.combineLatest5(
      readUserName(),
      readEmail(),
      readMobileNo(),
      readPassword(),
      readConfirmPassword(),
      (userName, email, mobile, password, confirmPassword) => true);

  //To accomodate new changes in the registration form fields
  void changeUserName(String newUserName) =>
      _userNameController.sink.add(newUserName);
  void changeEmail(String newEmail) => _emailController.sink.add(newEmail);
  void changeMobileNo(String newMobileNo) =>
      _mobileNoController.sink.add(newMobileNo);
  void changePassword(String newPassword) =>
      _passwordController.sink.add(newPassword);
  void changeConfirmPassword(String newConfirmPassword) =>
      _confirmPasswordController.sink.add(newConfirmPassword);

  Future<String> registerData(DatabaseInterface dbInteractor) async {
    final String validUserName = _userNameController.value;
    final String validEmail = _emailController.value;
    final int validMobile = int.parse(_mobileNoController.value);
    final String validPassword = _passwordController.value;

    final bool emailAlreadyExists =
        await dbInteractor.checkIfEmailExists(validEmail);
    if (emailAlreadyExists)
      return "$validEmail already exists. Please use a different email address.";

    final int insertionStatus = await dbInteractor.insertUser(UserModel(
        userName: validUserName,
        emailID: validEmail,
        mobileNo: validMobile,
        password: validPassword.hashCode,
        role: 2));

    String output;
    if (insertionStatus > 0) {
      output = "$validUserName is now registered as a new user.";
    } else {
      output = "Failed to perform registration.";
    }

    print(output);
    return output;
  }

  void dispose() {
    _userNameController.close();
    _emailController.close();
    _mobileNoController.close();
    _passwordController.close();
    _confirmPasswordController.close();
  }
}

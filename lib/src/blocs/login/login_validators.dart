// login_validators.dart defines the validators used by the login
// form's backend for validating the data entered by the user.

import 'dart:async';

class LoginValidators {
  static final int minCharInEmail = 5;
  static final int minCharInPassword = 5;
  static final String incorrectEmailError = "Incorrect email";
  static final String incorrectPasswordError =
      "Password should contain atleast $minCharInPassword charachters";

  final emailValidator = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink) {
      bool emailIsLargeEnough = (email.length >= minCharInEmail);
      bool emailContainsAtSymbol = (email.contains('@'));
      if (emailIsLargeEnough && emailContainsAtSymbol)
        sink.add(email);
      else
        sink.addError(incorrectEmailError);
    },
  );

  final passwordValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length >= minCharInPassword)
      sink.add(password);
    else
      sink.addError(incorrectPasswordError);
  });
}

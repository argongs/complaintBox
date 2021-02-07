import 'dart:async';

class LoginValidators {
  static final int minCharInUserName = 5;
  static final int minCharInPassword = 5;
  static final String incorrectUserNameErrorMessage =
      "User Name should contain atleast $minCharInUserName charachters";
  static final String incorrectPasswordErrorMessage =
      "Password should contain atleast $minCharInPassword charachters";

  final userNameValidator = StreamTransformer<String, String>.fromHandlers(
    handleData: (userName, sink) {
      if (userName.length >= minCharInUserName)
        sink.add(userName);
      else
        sink.addError(incorrectUserNameErrorMessage);
    },
  );

  final passwordValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length >= minCharInPassword)
      sink.add(password);
    else
      sink.addError(incorrectPasswordErrorMessage);
  });
}

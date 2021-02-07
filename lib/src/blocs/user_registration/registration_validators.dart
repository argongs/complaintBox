import 'dart:async';

class RegistrationValidators {
  static final int minCharInUserName = 5;
  static final int minCharInEmail = 7;
  static final int minCharInPassword = 5;
  static final String incorrectUserNameError =
      "User name should contain atleast $minCharInUserName charachters without space.";
  static final String incorrectEmailError = "Invalid email.";
  static final String incorrectPasswordError =
      "Password should contain atleast $minCharInPassword charachters.";

  // Validate user name
  final userNameValidator = StreamTransformer<String, String>.fromHandlers(
    handleData: (userName, sink) {
      bool nameIsLargeEnough = (userName.length >= minCharInUserName);
      bool nameContainsSpace = (userName.contains(' '));
      if (nameIsLargeEnough && !nameContainsSpace)
        sink.add(userName);
      else
        sink.addError(incorrectUserNameError);
    },
  );
  // Validate email
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
  // Validate password
  final passwordValidator = StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink) {
      bool passwordIsLargeEnough = (password.length >= minCharInPassword);
      if (passwordIsLargeEnough)
        sink.add(password);
      else
        sink.addError(incorrectPasswordError);
    },
  );

  final confirmPasswordValidator =
      StreamTransformer<List<String>, String>.fromHandlers(
    handleData: (passwordPair, sink) {
      String password = passwordPair[0];
      String confirmPassword = passwordPair[1];
      bool passwordMatchesConfirmPassword =
          (password.compareTo(confirmPassword) == 0);

      if (passwordMatchesConfirmPassword)
        sink.add(confirmPassword);
      else
        sink.addError("Password's don't match.");
    },
  );
}

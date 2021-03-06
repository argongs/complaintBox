// login_provider.dart defines a widget which is capable of holding
// an instance of the login form's backend. This allows the login
// form's frontend to easily call the functions from the backend.

import 'package:flutter/material.dart';
import 'login_bloc.dart';

class LoginProvider extends InheritedWidget {
  // Constructor of Provider
  // It will pass on the job of widget creation to Provider's superclass 'InheritedWidget'
  LoginProvider({Key key, Widget child}) : super(key: key, child: child);

  // For managing and validating data streams from Login screen
  final loginBloc = LoginBloc();

  bool updateShouldNotify(_) => true;

  static LoginBloc of(BuildContext context) =>
      (context.dependOnInheritedWidgetOfExactType<LoginProvider>()).loginBloc;
}

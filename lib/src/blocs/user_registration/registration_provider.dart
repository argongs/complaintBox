// registration_provider.dart defines a widget which is capable of holding
// an instance of the registration form's backend. This allows the registration
// form's frontend to easily call the functions from the backend.

import 'package:flutter/material.dart';
import 'registration_bloc.dart';

class RegistrationProvider extends InheritedWidget {
  RegistrationProvider({Key key, Widget child}) : super(key: key, child: child);

  final registrationBloc = RegistrationBloc();

  bool updateShouldNotify(_) => true;

  static RegistrationBloc of(BuildContext context) =>
      (context.dependOnInheritedWidgetOfExactType<RegistrationProvider>())
          .registrationBloc;
}

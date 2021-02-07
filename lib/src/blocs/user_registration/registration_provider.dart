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

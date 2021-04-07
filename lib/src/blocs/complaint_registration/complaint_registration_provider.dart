// complaint_registration_provider.dart defines a widget which is capable of
// holding an instance of the complaint registration form's backend.
// This allows the complaint registration form's frontend to easily call the
// functions from the backend.

import 'package:flutter/material.dart';
import 'complaint_registration_bloc.dart';

class ComplaintRegistrationProvider extends InheritedWidget {
  ComplaintRegistrationProvider({Key key, Widget child})
      : super(key: key, child: child);

  final registrationBloc = ComplaintRegistrationBloc();

  bool updateShouldNotify(_) => true;

  static ComplaintRegistrationBloc of(BuildContext context) => (context
          .dependOnInheritedWidgetOfExactType<ComplaintRegistrationProvider>())
      .registrationBloc;
}

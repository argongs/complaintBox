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

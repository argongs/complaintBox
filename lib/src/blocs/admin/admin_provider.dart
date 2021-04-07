// admin_provider.dart makes creates a widget which holds an instance to
// the admin screen's backend and makes the functions defined over there
// available to the admin screen frontend buttons

import 'package:flutter/material.dart';
import 'admin_bloc.dart';

class AdminProvider extends InheritedWidget {
  // Constructor of Provider
  // It will pass on the job of widget creation to Provider's superclass 'InheritedWidget'
  AdminProvider({Key key, Widget child}) : super(key: key, child: child);

  // For managing and validating data streams from Login screen
  final adminBloc = AdminBloc();

  bool updateShouldNotify(_) => true;

  static AdminBloc of(BuildContext context) =>
      (context.dependOnInheritedWidgetOfExactType<AdminProvider>()).adminBloc;
}

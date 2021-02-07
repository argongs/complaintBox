import 'package:flutter/material.dart';
import 'database_interface.dart';

class DatabaseProvider extends InheritedWidget {
  final dbInteractor = DatabaseInterface();

  /* Constructor of DatabaseProvider class will simply 
  delegate the responsibility of widget creation to the super class 
  i.e. the InheritedWidget
  */
  DatabaseProvider({Key key, Widget child}) : super(key: key, child: child) {
    /* Initialise the database as soon as an instance of this 
    class i.e. DatabaseProvider is created
    */
    dbInteractor.initialiseDatabase();
  }

  bool updateShouldNotify(_) => true;

  static DatabaseInterface of(BuildContext context) =>
      (context.dependOnInheritedWidgetOfExactType<DatabaseProvider>())
          .dbInteractor;
}

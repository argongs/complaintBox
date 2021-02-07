import 'package:flutter/material.dart';
import '../db/database_interface.dart';
import '../db/database_provider.dart';
import '../blocs/user_registration/registration_bloc.dart';
import '../blocs/user_registration/registration_provider.dart';

class RegistrationScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    final RegistrationBloc bloc = RegistrationProvider.of(context);
    final DatabaseInterface dbInteractor = DatabaseProvider.of(context);
    return Container(
      margin: EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          Container(margin: EdgeInsets.only(top: 25.0)),
          userNameField(bloc),
          Container(margin: EdgeInsets.only(top: 25.0)),
          emailField(bloc),
          Container(margin: EdgeInsets.only(top: 25.0)),
          passwordField(bloc),
          Container(margin: EdgeInsets.only(top: 25.0)),
          confirmPasswordField(bloc),
          Container(margin: EdgeInsets.only(top: 50.0)),
          registerButton(bloc, dbInteractor),
        ],
      ),
    );
  }

  Widget userNameField(RegistrationBloc bloc) {
    return StreamBuilder(
      stream: bloc.readUserName(),
      builder: (BuildContext context, snapshot) {
        return TextField(
          onChanged: bloc.changeUserName,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "John_Doe",
            labelText: "Enter your user name",
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

  Widget emailField(RegistrationBloc bloc) {
    return StreamBuilder(
      stream: bloc.readEmail(),
      builder: (BuildContext context, snapshot) {
        return TextField(
          onChanged: bloc.changeEmail,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "john_doe@example.com",
            labelText: "Enter your email id",
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

  Widget passwordField(RegistrationBloc bloc) {
    return StreamBuilder(
      stream: bloc.readPassword(),
      builder: (BuildContext context, snapshot) {
        return TextField(
          onChanged: bloc.changePassword,
          obscureText: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Enter your password",
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

  Widget confirmPasswordField(RegistrationBloc bloc) {
    return StreamBuilder(
      stream: bloc.readConfirmPassword(),
      builder: (BuildContext context, snapshot) {
        return TextField(
          onChanged: bloc.changeConfirmPassword,
          obscureText: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Confirm your password",
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

  Widget registerButton(RegistrationBloc bloc, DatabaseInterface dbInteractor) {
    return StreamBuilder(
      stream: bloc.canRegister(),
      builder: (BuildContext context, snapshot) {
        return RaisedButton(
          child: Text("Register"),
          onPressed: snapshot.hasData
              ? () {
                  bloc.registerData(dbInteractor);
                  //Navigator.pop(context);
                }
              : null,
        );
      },
    );
  }
}

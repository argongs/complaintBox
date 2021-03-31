import 'package:flutter/material.dart';
import '../db/database_interface.dart';
import '../db/database_provider.dart';
import '../blocs/user_registration/registration_bloc.dart';
import '../blocs/user_registration/registration_provider.dart';

class RegistrationScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    final RegistrationBloc bloc = RegistrationProvider.of(context);
    final DatabaseInterface dbInteractor = DatabaseProvider.of(context);
    final Size screenDimensions = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Registration"),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(
            horizontal: screenDimensions.width * 0.05,
            vertical: screenDimensions.height * 0.05),
        child: Column(
          children: <Widget>[
            userNameField(bloc),
            Container(margin: EdgeInsets.only(top: 25.0)),
            mobileField(bloc),
            Container(margin: EdgeInsets.only(top: 25.0)),
            emailField(bloc),
            Container(margin: EdgeInsets.only(top: 25.0)),
            Row(
              children: [
                SizedBox(
                  width: screenDimensions.width * 0.4,
                  child: passwordField(bloc),
                ),
                Container(
                    margin:
                        EdgeInsets.only(left: screenDimensions.height * 0.05)),
                SizedBox(
                  width: screenDimensions.width * 0.4,
                  child: confirmPasswordField(bloc),
                ),
              ],
            ),
            Container(margin: EdgeInsets.only(top: 50.0)),
            registerButton(bloc, dbInteractor),
          ],
        ),
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

  Widget mobileField(RegistrationBloc bloc) {
    return StreamBuilder(
      stream: bloc.readMobileNo(),
      builder: (BuildContext context, snapshot) {
        return TextField(
          onChanged: bloc.changeMobileNo,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "1234567890",
            labelText: "Mobile No.",
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
            labelText: "Password",
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
            labelText: "Confirm password",
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
              ? () async {
                  final String registrationMessage =
                      await bloc.registerData(dbInteractor);
                  Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text(registrationMessage)),
                  );
                }
              : null,
        );
      },
    );
  }
}

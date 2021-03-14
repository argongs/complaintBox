import 'package:flutter/material.dart';
import '../db/database_interface.dart';
import '../db/database_provider.dart';
import '../blocs/login/login_provider.dart';
import '../blocs/login/login_bloc.dart';

class LoginScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    final LoginBloc bloc = LoginProvider.of(context);
    final DatabaseInterface dbInteractor = DatabaseProvider.of(context);
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Container(margin: EdgeInsets.only(top: 25.0)),
            emailField(bloc),
            Container(margin: EdgeInsets.only(top: 25.0)),
            passwordField(bloc),
            Container(margin: EdgeInsets.only(top: 50.0)),
            submitButton(bloc, dbInteractor),
            registrationArea(context),
          ],
        ),
      ),
    );
  }
}

Widget emailField(LoginBloc bloc) {
  return StreamBuilder(
    stream: bloc.readEmail(),
    builder: (BuildContext context, snapshot) {
      return TextField(
        onChanged: bloc.changeEmail,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: "abc@example.com",
          labelText: "Email ID",
          errorText: snapshot.error,
        ),
      );
    },
  );
}

Widget passwordField(LoginBloc bloc) {
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

Widget submitButton(LoginBloc bloc, DatabaseInterface dbInteractor) {
  return StreamBuilder(
    stream: bloc.canSubmit(),
    builder: (BuildContext context, snapshot) {
      return RaisedButton(
        child: Text("Login"),
        onPressed: snapshot.hasData
            ? () async {
                int submissionStatus = await bloc.submitData(dbInteractor);
                if (submissionStatus == 0) {
                  Navigator.pushNamed(context, "/user_home");
                } else {
                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text("Incorrect Email or Password")));
                }
              }
            : null,
      );
    },
  );
}

Widget registrationArea(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text("Don't have an account yet?"),
      FlatButton(
        child: Text("Register here"),
        onPressed: () {
          Navigator.pushNamed(context, "/register");
        },
      ),
    ],
  );
}

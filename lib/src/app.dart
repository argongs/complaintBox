// 'app.dart' is the starting point of the app, i.e. it holds the code to draw
// the function call to the first screen seen by the user. It also contains the
// routing information required to route the app to appropriate screens.

import 'package:flutter/material.dart';
import 'package:sample/src/screens/user_info_screen.dart';
import 'blocs/complaint_registration/complaint_registration_provider.dart';
import 'screens/complaint_registration_screen.dart';
import 'screens/login_screen.dart';
import 'screens/user_registration_screen.dart';
import 'screens/user_home_screen.dart';
import 'screens/user_info_screen.dart';
import 'screens/complaint_info_screen.dart';
import 'screens/map_view_screen.dart';
import 'blocs/login/login_provider.dart';
import 'blocs/user_registration/registration_provider.dart';
import 'db/database_provider.dart';

class App extends StatelessWidget {
  Widget build(BuildContext context) {
    return DatabaseProvider(
      child: MaterialApp(
        title: "Login",
        onGenerateRoute: routes,
      ),
    );
  }

  Route routes(RouteSettings settings) {
    switch (settings.name) {
      case "/": // Login screen
        return MaterialPageRoute(
          builder: (BuildContext context) {
            return LoginProvider(
              child: LoginScreen(),
            );
          },
        );
      case "/register": // Registration screen
        return MaterialPageRoute(
          builder: (BuildContext context) {
            return RegistrationProvider(
              child: RegistrationScreen(),
            );
          },
        );
      case "/user_home": // User's Home screen (after logging in)
        return MaterialPageRoute(
          builder: (BuildContext context) {
            return UserHomeScreen();
          },
        );
      case "/user_home/register_complaint": // Complaint registration screen
        return MaterialPageRoute(
          builder: (BuildContext context) {
            return ComplaintRegistrationProvider(
              child: ComplaintRegistrationScreen(purpose: 0),
            );
          },
        );
      case "/user_home/edit_complaint": // Complaint editing screen
        return MaterialPageRoute(
          builder: (BuildContext context) {
            return ComplaintRegistrationProvider(
              child: ComplaintRegistrationScreen(purpose: 1),
            );
          },
        );
      case "/user_home/user_info": // User Info screen
        return MaterialPageRoute(builder: (BuildContext context) {
          return UserInfoScreen();
        });
      case "/user_home/complaint_info": // Complaint Info screen
        return MaterialPageRoute(builder: (BuildContext context) {
          return ComplaintInfoScreen();
        });
      case "/user_home/map_view": // Map view of complaints
        return MaterialPageRoute(builder: (BuildContext context) {
          return MapViewScreen();
        });
      default:
        return null;
    }
  }
}

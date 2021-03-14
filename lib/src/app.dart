import 'package:flutter/material.dart';
import 'package:sample/src/screens/user_info_screen.dart';
import 'blocs/complaint_registration/complaint_registration_provider.dart';
import 'screens/complaint_registration_screen.dart';
import 'screens/login_screen.dart';
import 'screens/user_registration_screen.dart';
import 'screens/user_home_screen.dart';
import 'screens/user_info_screen.dart';
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
      case "/user_home/register_complaint": // Complaint screen
        return MaterialPageRoute(
          builder: (BuildContext context) {
            return ComplaintRegistrationProvider(
              child: ComplaintRegistrationScreen(),
            );
          },
        );
      case "/user_home/user_info":
        return MaterialPageRoute(builder: (BuildContext context) {
          return UserInfoScreen();
        });
      default:
        return null;
    }
  }
}

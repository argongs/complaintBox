import 'package:flutter/material.dart';
import 'admin_user_screen.dart';
import '../db/database_provider.dart';
import '../db/database_interface.dart';
import '../blocs/admin/admin_provider.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({Key key}) : super(key: key);

  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  Widget build(BuildContext context) {
    final DatabaseInterface dbInteractor = DatabaseProvider.of(context);
    final int userPriviledge = dbInteractor.getLoggedInUserData().role;
    switch (userPriviledge) {
      case 0: // Admin
        return AdminProvider(
          child: AdminScreen(dbInteractor: dbInteractor),
        );
      case 1: // Active user
        return activeUserContents(context, dbInteractor);
      case 2: // New user
        return newUserContents(dbInteractor);
    }
  }

  Widget activeUserContents(
      BuildContext context, DatabaseInterface dbInteractor) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello ${dbInteractor.getLoggedInUserData().userName}!"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                print("Rebuilt the user home screen");
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.map),
            onPressed: () {
              Navigator.pushNamed(context, "/user_home/map_view");
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: dbInteractor.obtainElaboratedComplaints(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done)
            return complaintList(snapshot.data, dbInteractor);
          else
            return CircularProgressIndicator();
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add complaints",
        child: Icon(Icons.add),
        onPressed: () =>
            Navigator.pushNamed(context, "/user_home/register_complaint"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget newUserContents(DatabaseInterface dbInteractor) {
    String message = '''
    Welcome to this app!\n
    Currently you are a new user.\n
    Until the admin acknowledges your existence, you'll have to wait in order to
    recieve your complaint registration priviledge''';

    return Scaffold(
      appBar: AppBar(
        title:
            Text("Greetings ${dbInteractor.getLoggedInUserData().userName}!"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 2.5),
            child: Text(
              message,
              maxLines: 6,
            ),
          )
        ],
      ),
    );
  }

  Widget complaintList(queryResults, DatabaseInterface dbInteractor) {
    if (queryResults == null)
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("You are now acknowledged by the admin."),
          Text("All the complaints made by you will appear over here."),
          Text("Tap on the '+' button below to add complaints.")
        ],
      );
    else
      return ListView.builder(
        itemCount: queryResults.length,
        itemBuilder: (BuildContext context, index) {
          final complaint = queryResults.elementAt(index);
          DateTime dateOfComplaint = complaint.timestamp;
          return ListTile(
            title: Text(complaint.shortDescription),
            subtitle: Row(
              children: <Widget>[
                Text(
                    "${dateOfComplaint.day}/${dateOfComplaint.month}/${dateOfComplaint.year}"),
                Container(
                  margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.05),
                ),
                Text("${complaint.complaintStatus}"),
              ],
            ),
            trailing: Icon(Icons.arrow_right),
            onTap: () {
              dbInteractor.setElaboratedComplaintTuple(complaint);
              Navigator.pushNamed(context, "/user_home/complaint_info");
            },
          );
        },
      );
  }
}

import 'package:flutter/material.dart';
import '../db/database_provider.dart';
import '../db/database_interface.dart';

class UserHomeScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    final DatabaseInterface dbInteractor = DatabaseProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello ${dbInteractor.getLoggedInUserName()}!"),
      ),
      body: FutureBuilder(
        future: dbInteractor.obtainComplaints(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done)
            return complaintList(snapshot.data);
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

  Widget complaintList(queryResults) {
    if (queryResults == null)
      return Text(
        "All the complaints made by you will appear over here.\nTap on the button below to add complaints",
        style: TextStyle(fontSize: 16),
      );
    else
      return ListView.builder(
        itemCount: queryResults.length,
        itemBuilder: (BuildContext context, index) {
          final complaint = queryResults.elementAt(index);
          return ListTile(
            title: Text(complaint.timestamp.toString()),
            subtitle: Text(complaint.issue),
          );
        },
      );
  }
}

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../blocs/complaint_registration/complaint_registration_provider.dart';
import '../blocs/complaint_registration/complaint_registration_bloc.dart';
import '../db/database_interface.dart';
import '../db/database_provider.dart';

class ComplaintRegistrationScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    final ComplaintRegistrationBloc bloc =
        ComplaintRegistrationProvider.of(context);
    final DatabaseInterface dbInteractor = DatabaseProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Register complaint"),
      ),
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Container(margin: EdgeInsets.only(top: 25.0)),
            locationField(bloc),
            Container(margin: EdgeInsets.only(top: 25.0)),
            imageField(bloc),
            Container(margin: EdgeInsets.only(top: 25.0)),
            issueField(bloc),
            Container(margin: EdgeInsets.only(top: 50.0)),
            submitButton(bloc, dbInteractor),
          ],
        ),
      ),
    );
  }

  Widget locationField(ComplaintRegistrationBloc bloc) {
    return StreamBuilder(
      stream: bloc.readLocation(),
      builder: (BuildContext context, snapshot) {
        return Column(
          children: [
            Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.2),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: TextField(
                    controller: TextEditingController(
                        text: snapshot.hasData
                            ? snapshot.data[0].toString()
                            : "N/A"),
                    enabled: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Latitude",
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.025,
                      right: MediaQuery.of(context).size.width * 0.025),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: TextField(
                    controller: TextEditingController(
                        text: snapshot.hasData
                            ? snapshot.data[1].toString()
                            : "N/A"),
                    enabled: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Longitude",
                    ),
                  ),
                ),
              ],
            ),
            RaisedButton(
              child: Text("Grab your location"),
              onPressed: () => bloc.obtainLocation(),
            ),
          ],
        );
      },
    );
  }

  Widget imageField(ComplaintRegistrationBloc bloc) {
    return StreamBuilder(
      stream: bloc.readImage(),
      builder: (BuildContext context, streamSnapshot) {
        return Column(
          children: <Widget>[
            streamSnapshot.hasData ? Image.file(streamSnapshot.data) : Text(""),
            RaisedButton(
              child: Text("Obtain image"),
              onPressed: () => Navigator.pushNamed(
                  context, "/user_home/register_complaint/click_image"),
            ),
          ],
        );
      },
    );
  }

  Widget issueField(ComplaintRegistrationBloc bloc) {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: "This road has way too many cracks to count",
        labelText: "Issue Description",
      ),
    );
  }

  Widget submitButton(
      ComplaintRegistrationBloc bloc, DatabaseInterface dbInteractor) {
    return RaisedButton(
      child: Text("Submit"),
      onPressed: null,
    );
  }
}

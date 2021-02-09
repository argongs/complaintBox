import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../blocs/complaint_registration/complaint_registration_provider.dart';
import '../blocs/complaint_registration/complaint_registration_bloc.dart';
import '../db/database_interface.dart';
import '../db/database_provider.dart';

class ComplaintRegistrationScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    final ComplaintRegistrationBloc bloc =
        ComplaintRegistrationProvider.of(context);
    final DatabaseInterface dbInteractor = DatabaseProvider.of(context);
    final ImagePicker picker = ImagePicker();

    return Scaffold(
      appBar: AppBar(
        title: Text("Register complaint"),
      ),
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
            Container(margin: EdgeInsets.only(top: 25.0)),
            locationField(bloc),
            Container(margin: EdgeInsets.only(top: 25.0)),
            imageField(bloc, picker),
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

  Widget imageField(ComplaintRegistrationBloc bloc, ImagePicker picker) {
    return StreamBuilder(
      stream: bloc.readImage(),
      builder: (BuildContext context, streamSnapshot) {
        return Column(
          children: <Widget>[
            streamSnapshot.hasData
                ? Image.file(File(streamSnapshot.data))
                : Text(""),
            RaisedButton(
              child: Text("Obtain image"),
              onPressed: () async {
                final PickedFile pickedFile =
                    await picker.getImage(source: ImageSource.camera);
                if (pickedFile != null) bloc.changeImage(pickedFile.path);
              },
            ),
          ],
        );
      },
    );
  }

  Widget issueField(ComplaintRegistrationBloc bloc) {
    return StreamBuilder(
      stream: bloc.readIssue(),
      builder: (BuildContext context, streamSnapshot) {
        return TextField(
          onChanged: bloc.changeIssue,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "This road has way too many cracks to count",
              labelText: "Issue Description",
              errorText: streamSnapshot.error),
        );
      },
    );
  }

  Widget submitButton(
      ComplaintRegistrationBloc bloc, DatabaseInterface dbInteractor) {
    return StreamBuilder(
      stream: bloc.canRegister(),
      builder: (BuildContext context, streamSnapshot) {
        return RaisedButton(
          child: Text("Submit"),
          onPressed: streamSnapshot.hasData
              ? () async {
                  int insertionStatus = await bloc.registerData(dbInteractor);
                  if (insertionStatus > 1) Navigator.pop(context);
                }
              : null,
        );
      },
    );
  }
}

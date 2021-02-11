import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../blocs/complaint_registration/complaint_registration_provider.dart';
import '../blocs/complaint_registration/complaint_registration_bloc.dart';
import '../db/complaint_model.dart';
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
        margin: EdgeInsets.all(8),
        child: ListView(
          children: <Widget>[
            imageField(bloc, picker),
            Container(margin: EdgeInsets.only(top: 8.0)),
            issueField(bloc),
            Container(margin: EdgeInsets.only(top: 8.0)),
            locationField(bloc),
            Container(margin: EdgeInsets.only(top: 8.0)),
            defectField(context, bloc),
            Container(margin: EdgeInsets.only(top: 10.0)),
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
        return Row(
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.325,
              child: TextField(
                controller: TextEditingController(
                    text:
                        snapshot.hasData ? snapshot.data[0].toString() : "N/A"),
                enabled: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Latitude",
                  errorText: snapshot.error,
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.025)),
            IconButton(
              icon: Icon(
                snapshot.hasData ? Icons.gps_fixed : Icons.gps_not_fixed,
              ),
              iconSize: MediaQuery.of(context).size.width * 0.2,
              onPressed: () => bloc.obtainLocation(),
            ),
            Container(
                margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.025)),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.325,
              child: TextField(
                controller: TextEditingController(
                    text:
                        snapshot.hasData ? snapshot.data[1].toString() : "N/A"),
                enabled: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Longitude",
                  errorText: snapshot.error,
                ),
              ),
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
        return Row(
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.65,
              child: TextField(
                controller: TextEditingController(
                    text: streamSnapshot.hasData ? streamSnapshot.data : "N/A"),
                enabled: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Image File",
                  errorText: streamSnapshot.error,
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.05)),
            IconButton(
              icon: Icon(streamSnapshot.hasData
                  ? Icons.camera
                  : Icons.camera_outlined),
              iconSize: MediaQuery.of(context).size.width * 0.2,
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

  Widget defectField(BuildContext context, ComplaintRegistrationBloc bloc) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: severityLevel(bloc),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.025,
                  right: MediaQuery.of(context).size.width * 0.025),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: defectType(bloc),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: lengthField(bloc),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.025,
                  right: MediaQuery.of(context).size.width * 0.025),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: widthField(bloc),
            ),
          ],
        ),
      ],
    );
  }

  Widget severityLevel(ComplaintRegistrationBloc bloc) {
    List<String> severityLevels = ComplaintModel.severityMap.keys.toList();

    return StreamBuilder(
      stream: bloc.readSeverity(),
      builder: (BuildContext context, streamSnapshot) {
        return DropdownButton(
          value: 3,
          icon: Icon(Icons.arrow_drop_down),
          items: severityLevels.map<DropdownMenuItem<int>>((String level) {
            return DropdownMenuItem<int>(
              value: ComplaintModel.severityMap[level],
              child: Text(level),
            );
          }).toList(),
          onChanged: bloc.changeSeverity,
        );
      },
    );
  }

  Widget defectType(ComplaintRegistrationBloc bloc) {
    List<String> defectTypes = ComplaintModel.defectMap.keys.toList();

    return StreamBuilder(
      stream: bloc.readDefect(),
      builder: (BuildContext context, streamSnapshot) {
        return DropdownButton(
          value: 1,
          icon: Icon(Icons.arrow_drop_down),
          items: defectTypes.map<DropdownMenuItem<int>>((String defect) {
            return DropdownMenuItem<int>(
              value: ComplaintModel.defectMap[defect],
              child: Text(defect),
            );
          }).toList(),
          onChanged: bloc.changeDefect,
        );
      },
    );
  }

  Widget lengthField(ComplaintRegistrationBloc bloc) {
    return StreamBuilder(
        stream: bloc.readLength(),
        builder: (BuildContext context, streamSnapshot) {
          return TextField(
            onChanged: bloc.changeLength,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Length (m)",
                hintText: "10.0",
                errorText: streamSnapshot.error),
          );
        });
  }

  Widget widthField(ComplaintRegistrationBloc bloc) {
    return StreamBuilder(
        stream: bloc.readWidth(),
        builder: (BuildContext context, streamSnapshot) {
          return TextField(
            onChanged: bloc.changeWidth,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Width (m)",
                hintText: "10.0",
                errorText: streamSnapshot.error),
          );
        });
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

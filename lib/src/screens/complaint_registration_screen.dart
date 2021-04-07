// complaint_registration_screen.dart draws the form which allows the user to
// register complaints.

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../blocs/complaint_registration/complaint_registration_provider.dart';
import '../blocs/complaint_registration/complaint_registration_bloc.dart';
import '../db/models/defect_model.dart';
import '../db/models/defect_subtype_model.dart';
import '../db/models/severity_model.dart';
import '../db/database_interface.dart';
import '../db/database_provider.dart';

class ComplaintRegistrationScreen extends StatelessWidget {
  final int purpose;
  // 'purpose' specifies whether this screen is used for editing or
  // registering complaint. purpose will be set to 1 for registration and 0 for
  // editing.

  ComplaintRegistrationScreen({this.purpose});

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
          shrinkWrap: true,
          children: <Widget>[
            imageField(bloc, picker),
            Container(margin: EdgeInsets.only(top: 10.0)),
            locationField(bloc),
            Container(margin: EdgeInsets.only(top: 10.0)),
            issueField(bloc, dbInteractor, context),
            Container(margin: EdgeInsets.only(top: 10.0)),
            defectField(context, bloc, dbInteractor),
            Container(margin: EdgeInsets.only(top: 15.0)),
            submitButton(bloc, dbInteractor),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  // Draws the field which will be used to obtain location
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
              tooltip: "Grab your location",
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

  // Draws the field which will be used to obtain image
  Widget imageField(ComplaintRegistrationBloc bloc, ImagePicker picker) {
    return StreamBuilder(
      stream: bloc.readImage(),
      builder: (BuildContext context, streamSnapshot) {
        return Column(
          children: [
            streamSnapshot.hasData
                ? Image.file(
                    File(streamSnapshot.data),
                    scale: 0.5,
                  )
                : Text(""),
            Row(
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.65,
                  child: TextField(
                    controller: TextEditingController(
                        text: streamSnapshot.hasData
                            ? streamSnapshot.data
                            : "N/A"),
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
                      ? Icons.camera_alt
                      : Icons.camera_alt_outlined),
                  iconSize: MediaQuery.of(context).size.width * 0.2,
                  tooltip: "Click defect image!",
                  onPressed: () async {
                    final PickedFile pickedFile =
                        await picker.getImage(source: ImageSource.camera);
                    if (pickedFile != null) bloc.changeImage(pickedFile.path);
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }

  // Draws the field which will be used to obtain issue description
  Widget issueField(ComplaintRegistrationBloc bloc,
      DatabaseInterface dbInteractor, BuildContext context) {
    return Column(children: <Widget>[
      Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.45,
            child: StreamBuilder(
              stream: bloc.readShortDescription(),
              builder: (BuildContext context, streamSnapshot) {
                return TextField(
                  onChanged: bloc.changeShortDescription,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Crack issue",
                      labelText: "Issue",
                      errorText: streamSnapshot.error),
                );
              },
            ),
          ),
          Container(
            margin:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.45,
            child: severityLevel(bloc, dbInteractor),
          ),
        ],
      ),
      Container(
        margin: EdgeInsets.only(top: 10.0),
      ),
      StreamBuilder(
        stream: bloc.readDescription(),
        builder: (BuildContext context, streamSnapshot) {
          return TextField(
            onChanged: bloc.changeDescription,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "This road has way too many cracks to count",
                labelText: "Description",
                errorText: streamSnapshot.error),
          );
        },
      ),
    ]);
  }

  // Draws the outline of the container which will hold the fields
  // associated with defect-specific information
  Widget defectField(BuildContext context, ComplaintRegistrationBloc bloc,
      DatabaseInterface dbInteractor) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.45,
              child: defectType(bloc, dbInteractor),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.025),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.45,
              child: defectSubtype(bloc, dbInteractor),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: lengthField(bloc),
            ),
            Container(
              margin: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.025,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: widthField(bloc),
            ),
            Container(
              margin: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.025,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: depthField(bloc),
            ),
          ],
        ),
      ],
    );
  }

  // Draws the field which will be used to obtain defect severity
  Widget severityLevel(
      ComplaintRegistrationBloc bloc, DatabaseInterface dbInteractor) {
    return FutureBuilder(
      future: dbInteractor.obtainSeverities(),
      builder: (BuildContext context, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.done) {
          bloc.changeSeverity(futureSnapshot.data.first.severityCode);
          return StreamBuilder(
            stream: bloc.readSeverity(),
            builder: (BuildContext context, streamSnapshot) {
              return DropdownButton<int>(
                value: streamSnapshot.data,
                icon: Icon(Icons.arrow_drop_down),
                items: futureSnapshot.data
                    .map<DropdownMenuItem<int>>((SeverityModel severity) {
                  return DropdownMenuItem<int>(
                    value: severity.severityCode,
                    child: Text(severity.severityName),
                  );
                }).toList(),
                onChanged: bloc.changeSeverity,
              );
            },
          );
        } else
          return LinearProgressIndicator();
      },
    );
  }

  // Draws the field which will be used to obtain defect type
  Widget defectType(
      ComplaintRegistrationBloc bloc, DatabaseInterface dbInteractor) {
    return FutureBuilder(
      future: dbInteractor.obtainDefects(),
      builder: (BuildContext context, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.done &&
            futureSnapshot.hasData) {
          bloc.changeDefect(futureSnapshot.data.first.defectCode);
          return StreamBuilder(
            stream: bloc.readDefect(),
            builder: (BuildContext context, streamSnapshot) {
              return DropdownButton<int>(
                value: streamSnapshot.data,
                icon: Icon(Icons.arrow_drop_down),
                items: futureSnapshot.data
                    .map<DropdownMenuItem<int>>((DefectModel defectTuple) {
                  return DropdownMenuItem<int>(
                    value: defectTuple.defectCode,
                    child: Text(defectTuple.defectName),
                  );
                }).toList(),
                onChanged: bloc.changeDefect,
              );
            },
          );
        } else
          return LinearProgressIndicator();
      },
    );
  }

  // Draws the field which will be used to obtain defect subtype
  Widget defectSubtype(
      ComplaintRegistrationBloc bloc, DatabaseInterface dbInteractor) {
    return StreamBuilder(
      stream: bloc.readDefect(),
      builder: (BuildContext context, superStreamSnapshot) {
        if (superStreamSnapshot.hasData)
          return FutureBuilder(
            future: dbInteractor.obtainDefectSubtypes(superStreamSnapshot.data),
            builder: (BuildContext context, futureSnapshot) {
              if (futureSnapshot.connectionState == ConnectionState.done) {
                bloc.changeDefectSubtype(
                    futureSnapshot.data.first.defectSubtypeCode);
                return StreamBuilder(
                  stream: bloc.readDefectSubtype(),
                  builder: (BuildContext context, streamSnapshot) {
                    return DropdownButton<int>(
                      value: streamSnapshot.data,
                      icon: Icon(Icons.arrow_drop_down),
                      items: futureSnapshot.data.map<DropdownMenuItem<int>>(
                          (DefectSubtypeModel defectSubtypeTuple) {
                        return DropdownMenuItem<int>(
                          value: defectSubtypeTuple.defectSubtypeCode,
                          child: Text(defectSubtypeTuple.defectSubtypeName),
                        );
                      }).toList(),
                      onChanged: bloc.changeDefectSubtype,
                    );
                  },
                );
              } else
                return LinearProgressIndicator();
            },
          );
        else
          return LinearProgressIndicator();
      },
    );
  }

  // Draws the field which will be used to obtain length of the defect
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
      },
    );
  }

  // Draws the field which will be used to obtain width of the defect
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
      },
    );
  }

  // Draws the field which will be used to obtain depth of the defect
  Widget depthField(ComplaintRegistrationBloc bloc) {
    return StreamBuilder(
      stream: bloc.readDepth(),
      builder: (BuildContext context, streamSnapshot) {
        return TextField(
          onChanged: bloc.changeDepth,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Depth (m)",
              hintText: "10.0",
              errorText: streamSnapshot.error),
        );
      },
    );
  }

  // Draws the submit button and maps it to the function for complaint
  // registration
  Widget submitButton(
      ComplaintRegistrationBloc bloc, DatabaseInterface dbInteractor) {
    return StreamBuilder(
      stream: bloc.canRegister(),
      builder: (BuildContext context, streamSnapshot) {
        return RaisedButton(
          child: Text("Submit"),
          onPressed: streamSnapshot.hasData
              ? () async {
                  int complaintID = 0;

                  if (this.purpose == 1)
                    complaintID = dbInteractor.getElaboratedComplaintTuple().id;

                  await bloc.registerData(dbInteractor, complaintID);

                  Navigator.pop(context);
                }
              : null,
        );
      },
    );
  }
}

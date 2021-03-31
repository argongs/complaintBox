import 'dart:io';
import 'package:flutter/material.dart';
import '../db/database_provider.dart';
import '../db/database_interface.dart';
import '../db/elaborated_complaint_model.dart';

class ComplaintInfoScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    final DatabaseInterface dbInteractor = DatabaseProvider.of(context);
    final ElaboratedComplaintModel complaintInfo =
        dbInteractor.getElaboratedComplaintTuple();
    final int userPriviledgeLevel = dbInteractor.getLoggedInUserData().role;
    final Size screenDimensions = MediaQuery.of(context).size;
    final bool isEditingAllowed =
        complaintInfo.complaintStatusID == 0 && userPriviledgeLevel == 1;

    return Scaffold(
      appBar: AppBar(
        title: Text("Complaint Description"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: isEditingAllowed
                  ? () {
                      Navigator.pushNamed(context, "/user_home/edit_complaint");
                    }
                  : null)
        ],
      ),
      body: infoWidget(context, screenDimensions, complaintInfo,
          userPriviledgeLevel, dbInteractor),
    );
  }

  Widget infoWidget(
      BuildContext context,
      Size screenDimensions,
      ElaboratedComplaintModel complaintInfo,
      int userPriviledgeLevel,
      DatabaseInterface dbInteractor) {
    final bool isComplaintUpgradable =
        complaintInfo.complaintStatusID < 2 && userPriviledgeLevel == 0;

    return ListView(
      children: [
        Image.file(
          File(complaintInfo.imagePath),
          scale: 0.5,
        ),
        Row(children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: RichText(
              text: TextSpan(
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  children: [
                    TextSpan(
                        text: complaintInfo.width.toString(),
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: "m",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: "\nwide"),
                  ]),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: RichText(
              text: TextSpan(
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  children: [
                    TextSpan(
                        text: complaintInfo.length.toString(),
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: "m",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: "\nlong"),
                  ]),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: RichText(
              text: TextSpan(
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  children: [
                    TextSpan(
                      text: complaintInfo.depth.toString(),
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                        text: "m",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: "\ndeep"),
                  ]),
            ),
          ),
        ]),
        Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: Text(
                complaintInfo.defectName,
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: Text(
                complaintInfo.defectSubtypeName,
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: Text(
                  complaintInfo.severityName,
                  style: TextStyle(fontSize: 18),
                )),
          ],
        ),
        Container(
          margin: EdgeInsets.only(top: 5),
        ),
        Text(
          "Issue : " + complaintInfo.shortDescription,
          maxLines: 2,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          "Description : " + complaintInfo.description,
          maxLines: 10,
        ),
        isComplaintUpgradable
            ? RaisedButton(
                onPressed: () async {
                  await dbInteractor.upgradeComplaint();
                  Navigator.pop(context);
                },
                child: Text("Upgrade complaint status"))
            : Text("")
      ],
    );
  }
}

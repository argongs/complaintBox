// user_info_screen.dart draws out the basic info. related to a user

import 'package:flutter/material.dart';
import '../db/database_provider.dart';
import '../db/database_interface.dart';
import '../db/models/user_model.dart';

class UserInfoScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    final DatabaseInterface dbInteractor = DatabaseProvider.of(context);
    final UserModel userInfo = dbInteractor.getTempUserInfo();
    final Size screenDimensions = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("${userInfo.userName}'s Info."),
      ),
      body: infoWidget(context, screenDimensions, userInfo, dbInteractor),
    );
  }

  Widget infoWidget(BuildContext context, Size screenDimensions,
      UserModel userInfo, DatabaseInterface dbInteractor) {
    final bool canUserBeUpgraded = (userInfo.role == 2);
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: screenDimensions.width * 0.4,
              child: Text("Name"),
            ),
            Container(
              margin: EdgeInsets.only(left: screenDimensions.width * 0.1),
            ),
            SizedBox(
              width: screenDimensions.width * 0.4,
              child: Text(userInfo.userName),
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(
              width: screenDimensions.width * 0.4,
              child: Text("Email"),
            ),
            Container(
              margin: EdgeInsets.only(left: screenDimensions.width * 0.1),
            ),
            SizedBox(
              width: screenDimensions.width * 0.4,
              child: Text(userInfo.emailID),
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(
              width: screenDimensions.width * 0.4,
              child: Text("Mobile No."),
            ),
            Container(
              margin: EdgeInsets.only(left: screenDimensions.width * 0.1),
            ),
            SizedBox(
              width: screenDimensions.width * 0.4,
              child: Text("${userInfo.mobileNo}"),
            ),
          ],
        ),
        Container(margin: EdgeInsets.only(top: screenDimensions.height * 0.1)),
        canUserBeUpgraded
            ? RaisedButton(
                child: Text("Upgrade to Active"),
                onPressed: () {
                  dbInteractor.upgradeUser();
                  Navigator.pop(context);
                })
            : Text("")
      ],
    );
  }
}

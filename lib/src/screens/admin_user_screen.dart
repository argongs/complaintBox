import 'package:flutter/material.dart';
import '../db/database_interface.dart';
import '../db/role_model.dart';
import '../db/elaborated_complaint_model.dart';
import '../db/user_model.dart';
import '../db/complaint_status_model.dart';
import '../blocs/admin/admin_bloc.dart';
import '../blocs/admin/admin_provider.dart';

class AdminScreen extends StatelessWidget {
  final DatabaseInterface dbInteractor;
  //final AdminBloc bloc = AdminBloc();
  final List<String> tableNames = ["User", "Complaint"];

  AdminScreen({this.dbInteractor});

  Widget build(BuildContext context) {
    final AdminBloc bloc = AdminProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: tableName(bloc),
        actions: <Widget>[
          // IconButton(
          //   icon: Icon(Icons.file_download),
          //   onPressed: null,
          // ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
      drawer: Drawer(child: drawerList(context, bloc)),
      body: blocifiedScaffoldBody(bloc),
      bottomNavigationBar: tableSubtype(bloc),
    );
  }

  Widget tableName(AdminBloc bloc) {
    return StreamBuilder(
      stream: bloc.readTableName(),
      builder: (BuildContext context, streamSnapshot) {
        //if (!streamSnapshot.hasData) bloc.changeTable(0);
        if (streamSnapshot.hasData)
          return Text("${tableNames[streamSnapshot.data]} table");
        else {
          bloc.changeTable(0);
          return Text("Awaiting change...");
        }
      },
    );
  }

  Widget blocifiedScaffoldBody(AdminBloc bloc) {
    return StreamBuilder(
        stream: bloc.readTableName(),
        builder: (BuildContext context, superStreamSnapshot) {
          if (superStreamSnapshot.data == 0)
            return userData(bloc);
          else
            return complaintData(bloc);
        });
  }

  Widget userData(AdminBloc bloc) {
    return StreamBuilder(
        stream: bloc.readUserTableSubtype(),
        builder: (BuildContext context, streamSnapshot) {
          if (streamSnapshot.hasData) {
            return FutureBuilder(
              future: dbInteractor.obtainUserByRole(streamSnapshot.data),
              builder: (BuildContext context, futureSnapshot) {
                if (futureSnapshot.connectionState == ConnectionState.done) {
                  if (futureSnapshot.data == null)
                    return Center(child: Text("No data available"));
                  else {
                    final Iterable<UserModel> userList = futureSnapshot.data;
                    return ListView.builder(
                      itemCount: userList.length,
                      itemBuilder: (BuildContext context, int index) {
                        final UserModel userInfo = userList.elementAt(index);
                        return ListTile(
                          title: Text(userInfo.userName),
                          subtitle: Text(userInfo.emailID),
                          trailing: Icon(Icons.arrow_right),
                          onTap: () {
                            dbInteractor.setTempUserInfo(userInfo);
                            Navigator.pushNamed(
                                context, "/user_home/user_info");
                          },
                        );
                      },
                    );
                  }
                } else
                  return Center(
                    child: CircularProgressIndicator(),
                  );
              },
            );
          } else {
            bloc.changeUserTableSubtype(0);
            return Text("Awaiting");
          }
        });
  }

  Widget complaintData(AdminBloc bloc) {
    return StreamBuilder(
        stream: bloc.readComplaintTableSubtype(),
        builder: (BuildContext context, streamSnapshot) {
          if (streamSnapshot.hasData) {
            return FutureBuilder(
              future:
                  dbInteractor.obtainComplaintsByStatus(streamSnapshot.data),
              builder: (BuildContext context, futureSnapshot) {
                if (futureSnapshot.connectionState == ConnectionState.done) {
                  if (futureSnapshot.data == null)
                    return Center(child: Text("No data available"));
                  else {
                    final Iterable<ElaboratedComplaintModel> complaintList =
                        futureSnapshot.data;
                    return ListView.builder(
                      itemCount: complaintList.length,
                      itemBuilder: (BuildContext context, int index) {
                        final ElaboratedComplaintModel complaintInfo =
                            complaintList.elementAt(index);
                        return ListTile(
                          title: Text(complaintInfo.shortDescription),
                          subtitle: Text(complaintInfo.defectName),
                          trailing: Icon(Icons.arrow_right),
                          onTap: () {
                            dbInteractor
                                .setElaboratedComplaintTuple(complaintInfo);
                            Navigator.pushNamed(
                                context, "/user_home/complaint_info");
                          },
                        );
                      },
                    );
                  }
                } else
                  return Center(
                    child: CircularProgressIndicator(),
                  );
              },
            );
          } else {
            bloc.changeComplaintTableSubtype(0);
            return Text("Awaiting..");
          }
        });
  }

  Widget tableSubtype(AdminBloc bloc) {
    return StreamBuilder(
        stream: bloc.readTableName(),
        builder: (BuildContext context, streamSnapshot) {
          if (streamSnapshot.hasData) {
            if (streamSnapshot.data == 0) // For user tables
              return userTableSubtypes(bloc);
            else // For complaint tables
              return complaintTableSubtypes(bloc);
          } else {
            bloc.changeTable(0);
            return Text("Awaiting");
          }
        });
  }

  Widget userTableSubtypes(AdminBloc bloc) {
    return StreamBuilder(
        stream: bloc.readUserTableSubtype(),
        builder: (BuildContext context, streamSnapshot) {
          if (streamSnapshot.hasData) {
            return FutureBuilder(
              future: dbInteractor.obtainUserRoles(),
              builder: (BuildContext context, futureSnapshot) {
                if (futureSnapshot.connectionState == ConnectionState.done &&
                    futureSnapshot.hasData) {
                  final Iterable<RoleModel> roleList = futureSnapshot.data;
                  return BottomNavigationBar(
                    items: roleList
                        .map((userRole) => BottomNavigationBarItem(
                              icon: Icon(Icons.table_chart),
                              label: userRole.name,
                            ))
                        .toList(),
                    currentIndex: streamSnapshot.data,
                    onTap: bloc.changeUserTableSubtype,
                  );
                } else
                  return LinearProgressIndicator();
              },
            );
          } else {
            bloc.changeUserTableSubtype(0);
            return Text("Awaiting...");
          }
        });
  }

  Widget complaintTableSubtypes(AdminBloc bloc) {
    return StreamBuilder(
        stream: bloc.readComplaintTableSubtype(),
        builder: (BuildContext context, streamSnapshot) {
          if (streamSnapshot.hasData) {
            return FutureBuilder(
              future: dbInteractor.obtainComplaintStatusType(),
              builder: (BuildContext context, futureSnapshot) {
                if (futureSnapshot.connectionState == ConnectionState.done &&
                    futureSnapshot.hasData) {
                  final Iterable<ComplaintStatusModel> statusList =
                      futureSnapshot.data;
                  return BottomNavigationBar(
                    items: statusList
                        .map(
                          (complaintStatus) => BottomNavigationBarItem(
                              icon: Icon(Icons.table_chart),
                              label: complaintStatus.name),
                        )
                        .toList(),
                    currentIndex: streamSnapshot.data,
                    onTap: bloc.changeComplaintTableSubtype,
                  );
                } else
                  return LinearProgressIndicator();
              },
            );
          } else {
            bloc.changeComplaintTableSubtype(0);
            return Text("Awaiting");
          }
        });
  }

  Widget drawerList(BuildContext context, AdminBloc bloc) {
    return ListView(
      children: <Widget>[
        DrawerHeader(
          child: Text("Hello ${dbInteractor.getLoggedInUserData().userName}!",
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        ListTile(
            title: Text(
              "Data",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pop(context);
            }),
        ListTile(
          title: Text(tableNames[0]),
          onTap: () {
            bloc.changeTable(0);
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text(tableNames[1]),
          onTap: () {
            bloc.changeTable(1);
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text(
            "Miscellaneous",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          title: Text("Select account"),
          onTap: () {
            bloc.changeGoogleAccount();
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text("Backup"),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        // ListView(
        //   children: <Widget>[
        //     ,
        //   ],
        // ),
        // ListView(
        //   children: <Widget>[
        //
        //   ],
        // ),
      ],
    );
  }
}

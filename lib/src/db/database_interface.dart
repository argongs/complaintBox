// database_interface.dart is the place where all database related functions
// are defined. It acts as an interface to the database.

import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'models/user_model.dart';
import 'models/defect_model.dart';
import 'models/defect_subtype_model.dart';
import 'models/severity_model.dart';
import 'models/complaint_model.dart';
import 'models/elaborated_complaint_model.dart';
import 'models/complaint_status_model.dart';
import 'models/role_model.dart';

class DatabaseInterface {
  Database _database;
  static final String roleTableName = "roles";
  static final String userTableName = "users";
  static final String complaintTableName = "defectdata";
  static final String complaintStatusTableName = "defect_status";
  static final String complaintViewName = "elaboratedComplaint";
  static final String defectTableName = "defectTypes";
  static final String defectSubtypeTableName = "defectSubtypes";
  static final String severityTableName = "severityLevels";
  static final String databaseName = "roadalert.db";
  UserModel _loggedInUser, _tempUserInfo;
  String _pathToRecentCameraImage = "";
  ElaboratedComplaintModel _complaintTuple;

  UserModel getLoggedInUserData() {
    return _loggedInUser;
  }

  UserModel getTempUserInfo() {
    return _tempUserInfo;
  }

  String getPathToCameraImage() {
    return _pathToRecentCameraImage;
  }

  void setPathToCameraImage(String newPath) {
    _pathToRecentCameraImage = newPath;
  }

  void updateLoggedInUserName(UserModel newUserData) {
    _loggedInUser = newUserData;
  }

  void setTempUserInfo(UserModel userInfo) {
    _tempUserInfo = userInfo;
  }

  void setElaboratedComplaintTuple(ElaboratedComplaintModel tuple) {
    _complaintTuple = tuple;
  }

  ElaboratedComplaintModel getElaboratedComplaintTuple() {
    return _complaintTuple;
  }

  Future<void> initialiseDatabase() async {
    print("Database will be stored at " +
        join(await getDatabasesPath(), databaseName));
    _database = await openDatabase(
      join(await getDatabasesPath(), databaseName),
      version: 1,
      onCreate: (Database newDatabase, int version) async {
        print(
            "Cannot locate $databaseName database. Thus, it will be created.");

        // Create role table
        await newDatabase.execute('''
          CREATE TABLE $roleTableName
          (
            id    INTEGER     NOT NULL,
            name  VARCHAR(10) NOT NULL,
            PRIMARY KEY (id)
          );
        ''');

        // Create user table
        await newDatabase.execute('''
          CREATE TABLE $userTableName
          (
            id        INTEGER       PRIMARY KEY AUTOINCREMENT,
            name      VARCHAR(50)   NOT NULL,
            email     VARCHAR(50)   NOT NULL UNIQUE,
            mobile    INTEGER       NOT NULL,
            password  INTEGER       NOT NULL,
            role      INTEGER       NOT NULL,
            reg_date  TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (role) REFERENCES $roleTableName(id)
          );
        ''');

        // Create defect type table
        await newDatabase.execute('''
          CREATE TABLE $defectTableName
          (
            id    INTEGER     NOT NULL,
            name  VARCHAR(10) NOT NULL,
            PRIMARY KEY (id)
          );
        ''');

        // Create defect subtype table
        await newDatabase.execute('''
          CREATE TABLE $defectSubtypeTableName
          (
            id        INTEGER     NOT NULL,
            name      VARCHAR(10) NOT NULL,
            defect_id INTEGER     NOT NULL,
            PRIMARY KEY (id),
            FOREIGN KEY (defect_id) REFERENCES $defectTableName(id)
          );
        ''');

        // Create severity type table
        await newDatabase.execute('''
          CREATE TABLE $severityTableName
          (
            severityCode  INTEGER     NOT NULL,
            severityName  VARCHAR(10) NOT NULL,
            PRIMARY KEY (severityCode)
          );
        ''');

        // Create complaint status table
        await newDatabase.execute('''
          CREATE TABLE $complaintStatusTableName
          (
            id    INTEGER     NOT NULL,
            name  VARCHAR(10) NOT NULL,
            PRIMARY KEY (id)
          );
        ''');

        // Create complaint table
        await newDatabase.execute('''
          CREATE TABLE $complaintTableName
          (
            id                INTEGER     PRIMARY KEY AUTOINCREMENT,
            user_id           INTEGER     NOT NULL,
            timestamp         TIMESTAMP   UNIQUE DEFAULT CURRENT_TIMESTAMP,
            latitude          DOUBLE      NOT NULL,
            longitude         DOUBLE      NOT NULL,
            description       TEXT        NOT NULL,
            short_description TEXT        NOT NULL,
            img_name          TEXT        NOT NULL,
            severity          INTEGER     NOT NULL,
            defect_id         INTEGER     NOT NULL,
            subtype_id        INTEGER     NOT NULL,
            length            DOUBLE      NOT NULL,
            width             DOUBLE      NOT NULL,
            depth             DOUBLE      NOT NULL,
            status_id         INTEGER     DEFAULT 0,          
            FOREIGN KEY (user_id) REFERENCES $userTableName(id),
            FOREIGN KEY (defect_id) REFERENCES $defectTableName(id),
            FOREIGN KEY (subtype_id) REFERENCES $defectSubtypeTableName(id),
            FOREIGN KEY (severity) REFERENCES $severityTableName(severityCode),
            FOREIGN KEY (status_id) REFERENCES $complaintStatusTableName(id)
          );
        ''');

        // Create a view which will join complaint, defect and severity tables
        await newDatabase.execute('''
          CREATE VIEW $complaintViewName AS
          SELECT  complaints.*, defects.name, subtype.name, severity.severityName, status.name
          FROM  
            $complaintTableName AS complaints,
            $defectTableName AS defects,
            $defectSubtypeTableName AS subtype,  
            $severityTableName AS severity,
            $complaintStatusTableName AS status
          WHERE
            complaints.defect_id=defects.id AND
            subtype.defect_id=defects.id AND 
            complaints.subtype_id=subtype.id AND
            complaints.severity=severity.severityCode AND
            complaints.status_id=status.id;
        ''');

        // Populate the role table
        await newDatabase.execute('''
          INSERT INTO $roleTableName(id, name)
          VALUES
            (0, "Admin"),
            (1, "Active"),
            (2, "New");
        ''');

        // Populate the complaint status table
        await newDatabase.execute('''
          INSERT INTO $complaintStatusTableName(id, name)
          VALUES
            (0, "New"),
            (1, "Resolving"),
            (2, "Solved");
        ''');

        // Populate the user table
        await newDatabase.execute('''
          INSERT INTO $userTableName(name, email, mobile, password, role)
          VALUES      
          ('qwerty', 'a@b.com', 1234567890, ${"12345".hashCode}, 1),
          ('admin', 'admin@sample.com', 1234567890, ${"12345".hashCode}, 0);
        ''');

        // Populate the defect table
        await newDatabase.execute('''
          INSERT INTO $defectTableName(id, name)
          VALUES      
            (1, 'Crack'),
            (2, 'Pothole');
        ''');

        // Populate the defect subtype table
        await newDatabase.execute('''
          INSERT INTO $defectSubtypeTableName(id, name, defect_id)
          VALUES      
            (1, 'Crack 1', 1),
            (2, 'Crack 2', 1),
            (3, 'Crack 3', 1),
            (4, 'Pothole 1', 2),
            (5, 'Pothole 2', 2);
        ''');

        // Populate the severity table
        await newDatabase.execute('''
          INSERT INTO $severityTableName(severityCode, severityName)
          VALUES      
            (1, 'High Risk'),
            (2, 'Medium Risk'),
            (3, 'Low Risk');
        ''');
      },
    );
  }

  // For insertion of new user data into the database
  Future<int> insertUser(UserModel userModel) async {
    int insertionStatus = 0;

    try {
      insertionStatus = await _database.insert(
        userTableName,
        userModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
    } catch (DatabaseException) {
      print("Failed to register. Some database exception has occured.");
    }

    return insertionStatus;
  }

  // For insertion of new complaint data into the database
  Future<int> insertComplaint(ComplaintModel complaintModel) async {
    int insertionStatus = 0;

    try {
      insertionStatus = await _database.insert(
        complaintTableName,
        complaintModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
    } catch (DatabaseException) {
      print("Failed to register the complaint.");
    }

    return insertionStatus;
  }

  // For checking if a given email id exists
  Future<bool> checkIfEmailExists(String email) async {
    final List<Map<String, dynamic>> maps = await _database.query(
      userTableName,
      columns: null,
      where: "email = ?",
      whereArgs: [email],
    );

    if (maps.length > 0)
      return true;
    else
      return false;
  }

  // For returning of data from the database
  Future<dynamic> obtainUser(String email, String password) async {
    try {
      final List<Map<String, dynamic>> maps = await _database.query(
        userTableName,
        columns: null,
        where: "email = ? AND password = ?",
        whereArgs: [email, password.hashCode],
      );

      if (maps.length > 0) {
        print("Found a match for email $email");
        _loggedInUser = UserModel.fromDB(maps.first);
        return _loggedInUser;
      } else {
        print("Couldn't find a match for email $email");
        return null;
      }
    } catch (DatabaseException) {
      print(''' Database exception occured while trying to login with 
          email = $email and password = $password ''');
      return null;
    }
  }

  // For obtaining the predefined user roles from the database
  Future<dynamic> obtainUserRoles() async {
    final List<Map<String, dynamic>> maps = await _database.query(
      roleTableName,
      columns: null,
    );

    if (maps.length > 0)
      return maps.map((userRole) => RoleModel.fromDB(userRole));
    else
      return null;
  }

  // For obtaining user data by their role
  Future<dynamic> obtainUserByRole(int roleID) async {
    final List<Map<String, dynamic>> maps = await _database.query(
      userTableName,
      columns: null,
      where: 'role = ?',
      whereArgs: [roleID],
    );

    if (maps.length > 0)
      return maps.map((userRole) => UserModel.fromDB(userRole));
    else
      return null;
  }

  // For upgrading user's priviledge
  Future<int> upgradeUser() async {
    int upgradeStatus = 0;
    Map<String, int> updateEntry = {"role": 1};

    try {
      upgradeStatus = await _database.update(
        userTableName,
        updateEntry,
        where: "id = ?",
        whereArgs: [_tempUserInfo.id],
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
    } catch (DatabaseException) {
      print("Failed to upgrade user");
    }

    return upgradeStatus;
  }

  // For obtaining the complaints present in the database
  Future<dynamic> obtainComplaints() async {
    final List<Map<String, dynamic>> maps = await _database.query(
      complaintTableName,
      columns: null,
      where: "user_id = ?",
      whereArgs: [_loggedInUser.id],
    );

    if (maps.length > 0) {
      return maps
          .map((complaintEntry) => ComplaintModel.fromDB(complaintEntry));
    } else
      return null;
  }

  // For obtaining different statuses that could be assigned to a complaint
  // from the database
  Future<dynamic> obtainComplaintStatusType() async {
    final List<Map<String, dynamic>> maps = await _database.query(
      complaintStatusTableName,
      columns: null,
    );

    if (maps.length > 0)
      return maps.map((statusType) => ComplaintStatusModel.fromDB(statusType));
    else
      return null;
  }

  // For obtaining complaints by status from the database
  Future<dynamic> obtainComplaintsByStatus(int statusID) async {
    final List<Map<String, dynamic>> maps = await _database.query(
      complaintViewName,
      columns: null,
      where: 'status_id = ?',
      whereArgs: [statusID],
    );
    print(maps);
    if (maps.length > 0)
      return maps
          .map((complaint) => ElaboratedComplaintModel.fromDB(complaint));
    else
      return null;
  }

  // For obtaining updating complaint details in the database
  Future<int> updateComplaint(
      int complaintID, ComplaintModel complaintData) async {
    int updateStatus = 0;
    Map<String, dynamic> updateEntry = {
      "latitude": complaintData.latitude,
      "longitude": complaintData.longitude,
      "description": complaintData.description,
      "short_description": complaintData.shortDescription,
      "img_name": complaintData.imagePath,
      "severity": complaintData.severity,
      "defect_id": complaintData.typeOfDefect,
      "subtype_id": complaintData.defectSubtype,
      "length": complaintData.length,
      "width": complaintData.width,
      "depth": complaintData.depth,
      "status_id": complaintData.status
    };

    try {
      updateStatus = await _database.update(
        complaintTableName,
        updateEntry,
        where: "id = ?",
        whereArgs: [complaintID],
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
    } catch (DatabaseException) {
      print("Failed to upgrade complaint");
    }

    return updateStatus;
  }

  // For upgrading complaint's status from the database
  Future<int> upgradeComplaint() async {
    int upgradeStatus = 0;
    Map<String, int> updateEntry = {
      "status_id": (_complaintTuple.complaintStatusID + 1)
    };

    try {
      upgradeStatus = await _database.update(
        complaintTableName,
        updateEntry,
        where: "id = ?",
        whereArgs: [_complaintTuple.id],
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
    } catch (DatabaseException) {
      print("Failed to upgrade complaint");
    }

    return upgradeStatus;
  }

  // For obtaining different types of defects defined in the database
  Future<dynamic> obtainDefects() async {
    final List<Map<String, dynamic>> maps = await _database.query(
      defectTableName,
      columns: null,
    );

    if (maps.length > 0) {
      print("Obtained multiple defects");
      return maps.map((defectTuple) => DefectModel.fromDB(defectTuple));
    } else
      return null;
  }

  // For obtaining different defect subtypes defined in the database
  Future<dynamic> obtainDefectSubtypes(int defectCode) async {
    final List<Map<String, dynamic>> maps = await _database.query(
        defectSubtypeTableName,
        columns: ['id, name'],
        where: 'defect_id = ?',
        whereArgs: [defectCode]);

    if (maps.length > 0) {
      return maps.map((defectSubtypeTuple) =>
          DefectSubtypeModel.fromDB(defectSubtypeTuple));
    } else
      return null;
  }

  // For obtaining different defect severities defined in the database
  Future<dynamic> obtainSeverities() async {
    final List<Map<String, dynamic>> maps = await _database.query(
      severityTableName,
      columns: null,
    );

    if (maps.length > 0) {
      return maps.map((severityTuple) => SeverityModel.fromDB(severityTuple));
    } else
      return null;
  }

  // For obtaining elaborated complaints (after joining it with other tables)
  // from the database
  Future<dynamic> obtainElaboratedComplaints() async {
    final List<Map<String, dynamic>> maps = await _database.query(
      complaintViewName,
      columns: null,
      where: "user_id = ?",
      whereArgs: [_loggedInUser.id],
    );
    print(maps);
    if (maps.length > 0) {
      return maps.map((complaintViewTuple) =>
          ElaboratedComplaintModel.fromDB(complaintViewTuple));
    } else
      return null;
  }
}

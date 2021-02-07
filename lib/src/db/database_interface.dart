import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'user_model.dart';
import 'complaint_model.dart';

class DatabaseInterface {
  Database _database;
  static final String userTableName = "user";
  static final String complaintTableName = "complaint";
  static final String databaseName = "road_map_database.db";
  static final String defaultUserName = "qwerty";
  String _loggedInUser = defaultUserName;
  String _pathToRecentCameraImage = "";

  String getLoggedInUserName() {
    return _loggedInUser;
  }

  void setPathToCameraImage(String newPath) {
    _pathToRecentCameraImage = newPath;
  }

  void updateLoggedInUserName(String newUserName) {
    _loggedInUser = newUserName;
  }

  Future<void> initialiseDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), databaseName),
      version: 1,
      onCreate: (Database newDatabase, int version) async {
        print(
            "Cannot locate $databaseName database. Thus, it will be created.");

        // Create user table
        await newDatabase.execute('''
          CREATE TABLE $userTableName
          (
            userName  VARCHAR(50)   NOT NULL,
            emailID   VARCHAR(50),
            password  INT           NOT NULL,
            PRIMARY KEY (userName)
          );
        ''');

        // Create complaint table
        await newDatabase.execute('''
          CREATE TABLE $complaintTableName
          (
            userName          VARCHAR(50) NOT NULL,
            timestamp         INT         NOT NULL,
            latitude          DOUBLE      NOT NULL,
            longitude         DOUBLE      NOT NULL,
            locationAccuracy  DOUBLE      NOT NULL,
            issue             TEXT        NOT NULL,
            imagePath         TEXT        NOT NULL,
            PRIMARY KEY (userName, timestamp),
            FOREIGN KEY (userName) REFERENCES $userTableName(userName)
          );
        ''');

        // Populate the user table
        await newDatabase.execute('''
          INSERT INTO $userTableName(userName, emailID, password)
          VALUES      ('$defaultUserName', 'abc@example.com', ${defaultUserName.hashCode});
        ''');

        // Populate the complaint table
        await newDatabase.execute('''
          INSERT INTO 
          $complaintTableName(userName, timestamp, latitude, longitude, locationAccuracy, imagePath, issue)
          VALUES      
          ('$defaultUserName', 0, 0, 0, 0, 'path/to/image', 'Something messed up!');
        ''');
      },
    );
  }

  // For insertion of data into the database
  Future<int> insertUser(UserModel userModel) async {
    int insertionStatus = 0;

    try {
      insertionStatus = await _database.insert(
        userTableName,
        userModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
    } catch (DatabaseException) {
      print(
          "Failed to register. Entry with user name ${userModel.userName} already exists.");
    }

    return insertionStatus;
  }

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

  //For returning of data from the database
  Future<dynamic> obtainUser(String userName, String password) async {
    try {
      final maps = await _database.query(
        userTableName,
        columns: null,
        where: "userName = ? AND password = ?",
        whereArgs: [userName, password.hashCode],
      );

      if (maps.length > 0) {
        print("Found a match for user name $userName");
        return UserModel.fromDB(maps.first);
      } else {
        print("Couldn't find a match for user name $userName");
        return null;
      }
    } catch (DatabaseException) {
      print(''' Database exception occured while trying to login with 
          username = $userName and password = $password ''');
      return null;
    }
  }

  Future<dynamic> obtainComplaints() async {
    final maps = await _database.query(
      complaintTableName,
      columns: null,
      where: "userName = ?",
      whereArgs: [_loggedInUser],
    );

    if (maps.length > 0) {
      return maps
          .map((complaintEntry) => ComplaintModel.fromDB(complaintEntry));
    } else
      return null;
  }
}

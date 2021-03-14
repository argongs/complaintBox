import 'dart:async';

class AdminBloc {
  final StreamController<int> _tableController =
      StreamController<int>.broadcast();
  final StreamController<int> _userTableSubtypeController =
      StreamController<int>.broadcast();
  final StreamController<int> _complaintTableSubtypeController =
      StreamController<int>.broadcast();

  void changeTable(int newTable) => _tableController.sink.add(newTable);
  void changeUserTableSubtype(int newUserTableSubtype) =>
      _userTableSubtypeController.sink.add(newUserTableSubtype);
  void changeComplaintTableSubtype(int newComplaintTableSubtype) =>
      _complaintTableSubtypeController.sink.add(newComplaintTableSubtype);

  Stream<int> readTableName() => _tableController.stream;
  Stream<int> readUserTableSubtype() => _userTableSubtypeController.stream;
  Stream<int> readComplaintTableSubtype() =>
      _complaintTableSubtypeController.stream;

  void dispose() {
    _tableController.close();
    _userTableSubtypeController.close();
    _complaintTableSubtypeController.close();
  }
}

import 'dart:async';

class ComplaintRegistrationValidators {
  static final int minCharInImage = 0;
  static final int minCharInIssue = 10;
  static final String incorrectLocationError =
      "Location field cannot be empty.";
  static final String incorrectImageError = "Invalid image";
  static final String incorrectIssueError = "Issue field cannot be kept empty";

  // Validate location details
  final locationValidator =
      StreamTransformer<List<double>, List<double>>.fromHandlers(
    handleData: (location, sink) {
      if (location.length == 3)
        sink.add(location);
      else
        sink.addError(incorrectLocationError);
    },
  );

  // Validate image
  final imageValidator = StreamTransformer<String, String>.fromHandlers(
    handleData: (image, sink) {
      bool imageIsLargeEnough = (image.length >= minCharInImage);

      if (imageIsLargeEnough)
        sink.add(image);
      else
        sink.addError(incorrectImageError);
    },
  );

  // Validate password
  final issueValidator = StreamTransformer<String, String>.fromHandlers(
    handleData: (issue, sink) {
      bool issueIsLargeEnough = (issue.length >= minCharInIssue);
      if (issueIsLargeEnough)
        sink.add(issue);
      else
        sink.addError(incorrectIssueError);
    },
  );
}

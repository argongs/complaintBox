import 'dart:async';

class ComplaintRegistrationValidators {
  static final int minCharInImage = 5;
  static final int minCharInIssue = 10;
  static final String incorrectLocationError =
      "Location field cannot be empty.";
  static final String incorrectImageError = "Image is required";
  static final String incorrectIssueError = "Issue field cannot be kept empty";
  static final String incorrectLengthError = "Length has to be positive";
  static final String incorrectWidthError = "Width has to be positive";

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

  final lengthValidator = StreamTransformer<double, double>.fromHandlers(
    handleData: (length, sink) {
      bool lengthIsAppropriate = (length > 0);
      if (lengthIsAppropriate)
        sink.add(length);
      else
        sink.addError(incorrectLengthError);
    },
  );

  final widthValidator = StreamTransformer<double, double>.fromHandlers(
    handleData: (width, sink) {
      bool widthIsAppropriate = (width > 0);
      if (widthIsAppropriate)
        sink.add(width);
      else
        sink.addError(incorrectWidthError);
    },
  );
}

import 'dart:async';

class ComplaintRegistrationValidators {
  static final int minCharInImage = 5;
  static final int minCharInDescription = 10;
  static final String incorrectLocationError =
      "Location field cannot be empty.";
  static final String incorrectImageError = "Image is required";
  static final String incorrectDescriptionError =
      "Description field cannot have less than 10 charachters";
  static final String incorrectValueError = "+ve values only!";

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
  final descriptionValidator = StreamTransformer<String, String>.fromHandlers(
    handleData: (issue, sink) {
      bool descriptionIsLargeEnough = (issue.length >= minCharInDescription);
      if (descriptionIsLargeEnough)
        sink.add(issue);
      else
        sink.addError(incorrectDescriptionError);
    },
  );

  final lengthValidator = StreamTransformer<double, double>.fromHandlers(
    handleData: (length, sink) {
      bool lengthIsAppropriate = (length > 0);
      if (lengthIsAppropriate)
        sink.add(length);
      else
        sink.addError(incorrectValueError);
    },
  );
}

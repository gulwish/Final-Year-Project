import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('TaskAd Functionality', () {
    FlutterDriver driver;

    // Connect to the Flutter app before running the tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the app after running the tests.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('Verify Email Address for TaskAd Functionality', () async {
      // Launch the app or navigate to the initial landing page.
     
      await driver.requestData('{"command": "restart", "reason": "test"}');

      // Add code to perform the necessary preconditions like user registration.

      // Attempt to access the "TaskAd" functionality.
           final taskAdButton = find.byValueKey('taskAdButton');
      await driver.tap(taskAdButton);

      // Wait for a short duration to ensure the app processes the action.
      await driver.waitFor(const Duration(seconds: 2));

      // Verify the system's response. Check for the error message.
      // Replace 'errorMessageText' with the actual error message text.
      final errorMessage = find.text('Email Verification Required');

      // Expect that the error message is displayed.
      expect(errorMessage, isNotNull);
    });
  });
}

/*
This chunk of code implements all the test cases
using following command
flutter driver --target=test_driver/e2e.dart
 */

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Counter App', () {

    final counterTextFinder = find.byValueKey('counter_text');
    final buttonFinder = find.byTooltip('increment');
    final buttonAdd = find.byValueKey('add');
    final buttonSubtract = find.byValueKey('subtract');
    final alertText = find.byValueKey('alert_text');
    final buttonClose = find.byValueKey('close_button');

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('Increment the counter', () async {
      //Tap the floating action button
      await driver.tap(buttonFinder);
      //Verify that counter text has been increased by 1
      expect(await driver.getText(counterTextFinder), "1");
      //
      //tap on the button once more
      await driver.tap(buttonFinder);
      //Verify that counter text has been increased by 1 more
      expect(await driver.getText(counterTextFinder), "2");
      //
    });

    test('Testing the alert window',() async{
      //Tap the add button to open the alert box
      await driver.tap(buttonAdd);
      expect(await driver.getText(alertText), "Welcome to the dialog 2");
      //Tap cancel button to exit the dialog
      await driver.tap(buttonClose);
      //Tap on Subtract button
      await driver.tap(buttonSubtract);
      expect(await driver.getText(counterTextFinder), "1");
    });
  });
}
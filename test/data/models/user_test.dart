import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:streaming_mobile/data/models/user.dart';

import '../../fixtures/fixture_reader.dart';

main() {
  final tUserData = Data(
      id: "id",
      userName: "user_name",
      firstName: "first_name",
      lastName: "last_name",
      phoneNumber: "phone_number",
      password: "password",
      bio: "bio",
      createdAt: "created_at",
      updatedAt: "updated_at",
      deletedAt: "deleted_at");
  final tUser = User(data: tUserData, success: true, status: 200);

  group('user from json and to json', () {
    test('from Json', () async {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('user.json'));
      // act
      final result = User.fromJson(jsonMap);
      // assert
      expect(result, tUser);
    });

    test('to Json', () async {
      // arrange
      final expectedMap = {
        "data": {
          "id": "id",
          "user_name": "user_name",
          "first_name": "first_name",
          "last_name": "last_name",
          "phone_number": "phone_number",
          "password": "password",
          "bio": "bio",
          "created_at": "created_at",
          "updated_at": "updated_at",
          "deleted_at": "deleted_at"
        },
        "success": true,
        "status": 200
      };
      // act
      final result = tUser.toJson();
      // assert
      expect(result, expectedMap);
    });
  });
}

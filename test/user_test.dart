

import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:naytto/src/features/authentication/domain/user.dart';

void main(){
  test("firstName should return first name from name variable", () {
    User().name = "Janne Korhonen";
    expect(User().firstName, "Janne");
  });
  test("lastName should return last name from name variable", (){
    User().name = "Janne Korhonen";
    expect(User().lastName, "Korhonen");
  });
}


import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:naytto/src/features/authentication/domain/app_user.dart';

void main(){
  test("first and last name should be combined in name", () {
    AppUser().firstName = "Janne";
    AppUser().lastName = "Kovalainen";
    expect(AppUser().name, "Janne Kovalainen");
  });
  
}
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:naytto/src/constants/firestore_constants.dart';
import 'package:naytto/src/features/authentication/data/link_auth_to_db.dart';

final appUserProvider = ChangeNotifierProvider((ref) => AppUser());

/// Contains all relevant information on User
class AppUser extends ChangeNotifier {
  static final AppUser _instance = AppUser._internal();
  late String? _uid;
  String get uid => _uid!;
  set uid(String uid) {
    _uid = uid;
    notifyListeners();
  }

  String get name {
    return "$firstName $lastName";
  }

  String _housingCooperative = "";
  String get housingCooperative => _housingCooperative;
  set housingCooperative(String housingCooperative) {
    _housingCooperative = housingCooperative;
    notifyListeners();
  }

  String _firstName = "";
  String get firstName => _firstName;
  set firstName(String firstName) {
    _firstName = firstName;
    notifyListeners();
  }

  String _lastName = "";
  String get lastName => _lastName;
  set lastName(String lastName) {
    _lastName = lastName;
    notifyListeners();
  }

  String _apartmentId = "";
  String get apartmentId => _apartmentId;
  set apartmentId(String aparmentid) {
    _apartmentId = aparmentid;
    notifyListeners();
  }

  String _tel = "";
  String get tel => _tel;
  set tel(String tel) {
    _tel = tel;
    notifyListeners();
  }

  String _email = "";
  String get email => _email;
  set email(String email) {
    _email = email;
    notifyListeners();
  }

  factory AppUser() {
    return _instance;
  }

  AppUser._internal() {}

  /// Calls LinkAuthToDb function to create user in database
  ///
  /// Takes in userObject from Firebase authentication
  createUser(userObject) {
    uid = userObject.user.uid;
    email = userObject.user.email;
    LinkAuthToDb().searchForUserInDB(userObject).then((value) {
      if (!value) {
        LinkAuthToDb().createUserInDB(userObject).then;
      }
    }).onError((error, stackTrace) {
      throw Exception("$error \n $stackTrace");
    });
  }

  /// Fetches user data from database
  fetchUser() {
    if (housingCooperative == "" && email == "") {
      uid = FirebaseAuth.instance.currentUser!.uid;
      LinkAuthToDb().fetchUserData(uid).then((value) {
        if (value[FirestoreFields.usersEmail] != null) {
          email = value[FirestoreFields.usersEmail];
        }
        if (value[FirestoreFields.usersApartmentNumber] != null) {
          apartmentId = value[FirestoreFields.usersApartmentNumber];
        }
        if (value[FirestoreFields.usersHousingCooperative] != null) {
          housingCooperative = value[FirestoreFields.usersHousingCooperative];
        }
      }).onError((error, stackTrace) {
        throw Exception("$error \n $stackTrace");
      });
    }
  }
}

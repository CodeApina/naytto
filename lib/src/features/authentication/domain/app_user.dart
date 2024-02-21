import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:naytto/src/constants/firestore_constants.dart';
import 'package:naytto/src/features/authentication/data/link_auth_to_db.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

/// Contains all relevant information on User
class AppUser extends ChangeNotifier {
  static final AppUser _instance = AppUser._internal();
  final provider = Provider<AppUser>((ref) {
    return AppUser();
  });

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

  void reset() {
    uid = "";
    email = "";
    housingCooperative = "";
    firstName = "";
    lastName = "";
    apartmentId = "";
    tel = "";
  }

  // Calls LinkAuthToDb function to create user in database
  //
  // Takes in userObject from Firebase authentication
  // housingcooperative from authentication here too?
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

  // Fetches user data from database
  // returns true if everything is fine
  Future<bool> fetchUser() async {
    if (housingCooperative == "" && email == "") {
      uid = FirebaseAuth.instance.currentUser!.uid;
      var userData = await LinkAuthToDb().fetchUserData(uid);
      if (userData[FirestoreFields.userEmail] != null) {
        email = userData[FirestoreFields.userEmail];
      }

      if (userData[FirestoreFields.userHousingCooperative] != null) {
        housingCooperative = userData[FirestoreFields.userHousingCooperative];
        // awaits for another database query
        final result = await fetchUserFromResident(
            userData[FirestoreFields.userHousingCooperative]);
        if (result == true) {
          return Future.value(true);
        } else {
          return false;
        }
      }
    }
    // if nothings is done
    return true;
  }

  Future<bool> fetchUserFromResident(String housingCooperationName) {
    if (housingCooperative != "") {
      uid = FirebaseAuth.instance.currentUser!.uid;
      return LinkAuthToDb()
          .fetchUserDataFromResident(uid, housingCooperationName)
          .then((value) {
        //Cant login if data is not found
        if (value == null) {
          return Future.value(false);
        }
        if (value[FirestoreFields.residentApartmentNumber] != null) {
          apartmentId = value[FirestoreFields.residentApartmentNumber];
        }
        if (value[FirestoreFields.residentFirstName] != null) {
          firstName = value[FirestoreFields.residentFirstName];
        }
        if (value[FirestoreFields.residentLastName] != null) {
          lastName = value[FirestoreFields.residentLastName];
        }
        return Future.value(true);
      }).catchError((error, stackTrace) {
        throw Exception("$error \n $stackTrace");
      });
    }

    return Future.value(false);
  }
}

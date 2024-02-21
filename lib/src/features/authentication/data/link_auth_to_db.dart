import 'dart:async';
import '../../../constants/firestore_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LinkAuthToDb {
  var db = FirebaseFirestore.instance;

  /// Creates user in database
  ///
  /// Takes in userObject from Firebase authentication
  Future<bool> createUserInDB(userObject) {
    final docRef = db.collection(FirestoreCollections.users);
    return docRef
        .doc(userObject.user.uid)
        .set({FirestoreFields.userEmail: userObject.user.email}).then((value) {
      return true;
    }).onError((error, stackTrace) {
      throw Exception("$error \n $stackTrace");
    });
  }

  /// Searches the database for user
  ///
  /// Takes in userObject from Firebase authentication
  Future<bool> searchForUserInDB(userObject) {
    final docRef = db.collection(FirestoreCollections.users);
    return docRef.doc(userObject.user.uid).get().then((value) {
      if (value.exists) {
        return true;
      }
      return false;
    }).onError((error, stackTrace) {
      throw Exception("$error \n $stackTrace");
    });
  }

  /// Fetches user data from database
  ///
  /// Takes in uid from Firebase authentication
  // Future<dynamic> fetchUserData(uid) {
  //   final docRef = db.collection(FirestoreCollections.users);
  //   return docRef.doc(uid).get().then((DocumentSnapshot doc) {
  //     final data = doc.data() as Map<String, dynamic>;
  //     if (data.isNotEmpty) {
  //       return data;
  //     }
  //     return null;
  //   }).onError((error, stackTrace) {
  //     throw Exception("$error \n $stackTrace");
  //   });
  // }
  Future<dynamic> fetchUserData(uid) {
    final docRef = db.collection(FirestoreCollections.users).doc(uid);
    return docRef.get().then((DocumentSnapshot doc) {
      if (doc.exists) {
        return doc.data();
      }
      return null;
    }).onError((error, stackTrace) {
      throw Exception("$error \n $stackTrace");
    });
  }

  Future<dynamic> fetchUserDataFromResident(uid, housingCooperationName) {
    final docRef = db
        .collection(FirestoreCollections.housingCooperative)
        .doc(housingCooperationName)
        .collection("residents")
        .doc(uid);
    return docRef.get().then((DocumentSnapshot doc) {
      if (doc.exists) {
        return doc.data();
      }
      return null;
    }).onError((error, stackTrace) {
      throw Exception("$error \n $stackTrace");
    });
  }
}

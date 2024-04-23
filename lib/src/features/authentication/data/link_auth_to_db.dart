import 'dart:async';
import '../../../constants/firestore_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LinkAuthToDb {
  var db = FirebaseFirestore.instance;

  /// Fetches user data from database
  ///
  /// Takes in uid from Firebase authentication
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

  Future<dynamic> housingCooperativeContactInfo(housingCooperativeName){
    final firestore = FirebaseFirestore.instance;
    return firestore.collection(FirestoreCollections.housingCooperative)
    .doc(housingCooperativeName)
    .get()
    .then((DocumentSnapshot doc) {
      if (doc.exists){
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
        .collection(FirestoreCollections.residents)
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

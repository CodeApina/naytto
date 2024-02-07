import 'dart:async';
import 'package:flutter/foundation.dart';

import '../../../constants/firestore_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_core/firebase_core.dart';

class LinkAuthToDb {
  var db = FirebaseFirestore.instance;

  /// Checks residents collection for user
  Future<bool> checkDbForUser(uid) async {
    var dbref = db.collection(FirestoreCollections.residents);
    bool found = false;
    await dbref
        .where(FirestoreFields.residentResidentId, isEqualTo: uid)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        found = true;
      }
    }).onError((error, stackTrace) {
      throw Exception("$error \n $stackTrace");
    });
    return found;
  }

  /// Stores user in the database.
  ///
  /// Requires Map<String,Dynamic>[uid, email, tel].
  Future<bool> storeUserInDB(Map<String, dynamic> mapOfData) async {
    var dbref = db.collection(FirestoreCollections.residents);
    var docId = await dbref
        .where(FirestoreFields.residentResidentId, isEqualTo: mapOfData["uid"])
        .get()
        .then((querySnapshot) {
      return querySnapshot.docs[0].id;
    });
    return await dbref.doc(docId).set({
      FirestoreFields.residentEmail: mapOfData["email"],
      FirestoreFields.residentTel: mapOfData["tel"],
    }).then((value) {
      return true;
    }).onError((error, stackTrace) {
      throw Exception("$error \n $stackTrace");
    });
  }

  ///Links resident to user in db
  ///
  ///Requires uid AND both first AND last name OR one other parameter
  ///Returns true if resident matching users info is found and the linking is successful
  ///Else returns false
  Future<bool> linkResidentToUser(uid,
      {email, apartmentNumber, tel, firstName, lastName}) async {
    assert(
        (email != null ||
            apartmentNumber != null ||
            tel != null ||
            firstName != null && lastName != null),
        "First and last name or one other parameter required");
    var dbref = db.collection(FirestoreCollections.residents);
    String? residentId;

    if (email != null) {
      await dbref
          .where(FirestoreFields.residentEmail, isEqualTo: email)
          .get()
          .then((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          residentId = querySnapshot.docs[0].id;
        }
      }).onError((error, stackTrace) {
        throw Exception("$error \n $stackTrace");
      });
    }
    if (apartmentNumber != null && residentId == null) {
      await dbref
          .where(FirestoreFields.residentApartmentNumber,
              isEqualTo: apartmentNumber)
          .get()
          .then((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          residentId = querySnapshot.docs[0].id;
        }
      });
    }
    if (tel != null && residentId == null) {
      await dbref
          .where(FirestoreFields.residentTel, isEqualTo: tel)
          .get()
          .then((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          residentId = querySnapshot.docs[0].id;
        }
      }).onError((error, stackTrace) {
        throw Exception("$error \n $stackTrace");
      });
    }
    if (firstName != null && lastName != null && residentId == null) {
      await dbref
          .where(FirestoreFields.residentFirstName, isEqualTo: firstName)
          .where(FirestoreFields.residentLastName, isEqualTo: lastName)
          .get()
          .then((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          residentId = querySnapshot.docs[0].id;
        }
      }).onError((error, stackTrace) {
        throw Exception("$error \n $stackTrace");
      });
    }
    if (residentId == null) {
      return false;
    }
    return await dbref
        .doc(residentId)
        .set({FirestoreFields.residentResidentId: uid}).then(
      (value) {
        return true;
      },
    ).onError((error, stackTrace) {
      throw Exception("$error \n $stackTrace");
    });
  }

  Future<bool> createUserInDB(userObject) {
    final docRef = db.collection(FirestoreCollections.users);
    return docRef
        .doc(userObject.user.uid)
        .set({FirestoreFields.usersEmail: userObject.user.email}).then((value) {
      return true;
    }).onError((error, stackTrace) {
      throw Exception("$error \n $stackTrace");
    });
  }

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

  Future<dynamic> fetchUserData(uid) {
    final docRef = db.collection(FirestoreCollections.users);
    return docRef.doc(uid).get().then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      if (data.isNotEmpty) {
        return data;
      }
      return null;
    }).onError((error, stackTrace) {
      throw Exception("$error \n $stackTrace");
    });
  }
}

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_core/firebase_core.dart';

  Future<bool>checkDbForUser(email) async{
  await Firebase.initializeApp();
  var db = await FirebaseFirestore.instance;
  var dbref = db.collection("resident");
  bool found = false;
  try{
    var data = await dbref.where("email", isEqualTo: email).get().then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty){
        found = true;
      }

  }).onError((error, stackTrace) {
    print("Error checking db for user");
  });
  } on Exception catch(e){
    throw Exception('Exeption: $e');
  }
  return found;
}



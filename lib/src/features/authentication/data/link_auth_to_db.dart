import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_core/firebase_core.dart';
  class LinkAuthToDb{
    var db = FirebaseFirestore.instance;
    Future<bool>checkDbForUser(uid) async{
      
      var dbref = db.collection("resident");
      bool found = false;
      try{
        var data = await dbref.where("uid", isEqualTo: uid).get().then((querySnapshot) {
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

    Future<bool>storeUserInDB(uid) async{
      var dbref = db.collection("resident");

      return false;
    }
  }



import 'dart:async';
import '../../../constants/firestore_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_core/firebase_core.dart';
  class LinkAuthToDb{
    var db = FirebaseFirestore.instance;

    /// Checks residents collection for user
    Future<bool>checkDbForUser(uid) async{
      
      var dbref = db.collection(FirestoreCollections.residents);
      bool found = false;
      try{
        await dbref.where(FirestoreFields.residentResidentId, isEqualTo: uid).get().then((querySnapshot) {
          if (querySnapshot.docs.isNotEmpty){
            found = true;
          }
      }).onError((error, stackTrace) {
        print("Error: $error  \n $stackTrace");
      });
      } on Exception catch(error){
        throw Exception('Exeption: $error');
      }
      return found;
    } 
    /// Stores user in the database.
    ///
    /// Requires Map<String,Dynamic>[uid, email, firstName, lastName, tel, apartmentNumber].
    Future<bool>storeUserInDB(Map<String,dynamic>mapOfData) async{
      var dbref = db.collection(FirestoreCollections.residents);
      return await dbref.add({
        FirestoreFields.residentResidentId: mapOfData["uid"],
        FirestoreFields.residentEmail: mapOfData["email"],
        FirestoreFields.residentFirstName: mapOfData["firstName"],
        FirestoreFields.residentLastName: mapOfData["lastName"],
        FirestoreFields.residentApartmentId: mapOfData["apartmentNumber"],
        FirestoreFields.residentTel: mapOfData["tel"],
      }).then((value) {
        return true;
      }).onError((error, stackTrace) {
        print("Error: $error  \n $stackTrace");
        return false;
      });
    }

    ///Links resident to user in db
    ///
    ///Requires uid AND both first AND last name OR one other parameter
    Future<bool>linkResidentToUser(uid, {email, apartmentNumber, tel, firstName, lastName}) async{
      assert((email != null || apartmentNumber != null || tel != null || firstName != null && lastName != null), "First and last name or one other parameter required");
      var dbref = db.collection(FirestoreCollections.residents);
      String? residentId;
      
      if(email != null){
        await dbref.where(FirestoreFields.residentEmail, isEqualTo: email).get().then((querySnapshot) {
          if(querySnapshot.docs.isNotEmpty){
            residentId = querySnapshot.docs[0].id;
          }
        }).onError((error, stackTrace){
          print("Error: $error \n $stackTrace");
         });
      }
      if(apartmentNumber != null && residentId == null){
        await dbref.where(FirestoreFields.residentApartmentId, isEqualTo : apartmentNumber).get().then((querySnapshot) {
          if (querySnapshot.docs.isNotEmpty){
            residentId = querySnapshot.docs[0].id; 
          }
        });
      }
      if (tel != null && residentId == null){
        await dbref.where(FirestoreFields.residentTel, isEqualTo : tel).get().then((querySnapshot) {
          if (querySnapshot.docs.isNotEmpty){
            residentId = querySnapshot.docs[0].id; 
          }
        }).onError((error, stackTrace) {
          print("Error: $error \n $stackTrace");
        });
      }
      if(firstName != null && lastName != null && residentId == null){
        await dbref.where(FirestoreFields.residentFirstName, isEqualTo : firstName).where(FirestoreFields.residentLastName, isEqualTo: lastName).get().then((querySnapshot) {
          if (querySnapshot.docs.isNotEmpty){
            residentId = querySnapshot.docs[0].id; 
          }
        }).onError((error, stackTrace) {
          print("Error: $error \n $stackTrace");
        });
      }
      if (residentId == null){
        print("Error: User not found");
        return false;
      }
      return await dbref.doc(residentId).set({FirestoreFields.residentResidentId : uid}).then((value) {
        return true;
      },).onError((error, stackTrace) {
        print("Error: $error \n $stackTrace");
        return false;
      });
    }
  }



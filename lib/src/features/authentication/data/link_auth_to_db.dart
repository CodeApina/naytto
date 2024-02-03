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
        var data = await dbref.where(FirestoreFields.residentResidentId, isEqualTo: uid).get().then((querySnapshot) {
          if (querySnapshot.docs.isNotEmpty){
            found = true;
          }
      }).onError((error, stackTrace) {
        print("Error: $error  \n $stackTrace");
      });
      } on Exception catch(e){
        throw Exception('Exeption: $e');
      }
      return found;
    } 
    /// Stores user in the database.
    ///
    /// Requires Map<String,Dynamic>[uid, email, firstName, lastName, tel, apartmentNumber].
    Future<bool>storeUserInDB(Map<String,dynamic>mapOfData) async{
      var dbref = db.collection(FirestoreCollections.apartments);
      var apartmentId = await dbref.where(FirestoreFields.apartmentsNumber, isEqualTo: mapOfData["apartmentNumber"]);
      dbref = db.collection(FirestoreCollections.residents);
      return await dbref.add({
        FirestoreFields.residentResidentId: mapOfData["uid"],
        FirestoreFields.residentEmail: mapOfData["email"],
        FirestoreFields.residentFirstName: mapOfData["firstName"],
        FirestoreFields.residentLastName: mapOfData["lastName"],
        FirestoreFields.residentApartmentId: apartmentId,
        FirestoreFields.residentTel: mapOfData["tel"],
      }).then((value) {
        return true;
      }).onError((error, stackTrace) {
        print("Error: $error  \n $stackTrace");
        return false;
      });
      
    }
  }



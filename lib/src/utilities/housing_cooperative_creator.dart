

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:naytto/src/constants/firestore_constants.dart';

class HousingCooperativeCreator{
  var db = FirebaseFirestore.instance;

  Future<bool>CreateNewHousingCooperative() async{
    return db.collection(FirestoreCollections.housingCooperative).doc("Pilvilinna").set({
      FirestoreFields.housingCooperativeAddress: "Tuuttikatu 3"}).then((value)
      {
        return db.collection(FirestoreCollections.housingCooperative).doc("Pilvilinna").collection(FirestoreCollections.residents).add({
          FirestoreFields.residentApartmentNumber: "A1",
          FirestoreFields.residentEmail: "janne.korhonen@luukku.fi",
          FirestoreFields.residentFirstName: "Janne",
          FirestoreFields.residentLastName: "Korhonen",
          FirestoreFields.residentTel: "0468543978"
        }).then((documentSnapshot) {
          return db.collection(FirestoreCollections.housingCooperative).doc("Pilvilinna").collection(FirestoreCollections.apartments).doc("A1").collection(FirestoreCollections.apartmentsResidents).doc().set({
            FirestoreFields.apartmentsResidentsReference: "/${FirestoreCollections.housingCooperative}/Pilvilinna/${documentSnapshot.id}"
          }).then((value) {
            return db.collection(FirestoreCollections.housingCooperative).doc("Pilvilinna").collection(FirestoreCollections.announcements).doc().set({
              FirestoreFields.
            });
          });
        });
      });
  }
}
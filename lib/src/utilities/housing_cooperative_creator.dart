

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
              FirestoreFields.announcementBody: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse semper imperdiet elit, sit amet finibus ex vulputate vel. Fusce sagittis volutpat sem, a rhoncus sapien pretium ac. Vestibulum posuere, tellus at sollicitudin iaculis, libero lacus facilisis ipsum, et accumsan odio massa at felis. Duis ac tortor ultrices turpis vestibulum bibendum. Praesent ornare leo eget dapibus euismod. Curabitur elementum purus libero, eget dapibus lectus hendrerit quis. Duis id tincidunt quam. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Praesent placerat vel augue id fringilla. Sed congue semper nibh, auctor molestie lectus tempus nec. Curabitur pretium leo leo, venenatis congue purus molestie sit amet. Aliquam sem magna, aliquam vitae risus id, maximus scelerisque velit. Quisque dui dolor, ullamcorper vel tellus non, tempus lacinia libero.",
              FirestoreFields.announcementTitle: "Lorem ipsum dolor sit amet",
              FirestoreFields.announcementTimestamp: DateTime.now(),
              FirestoreFields.announcementUrgency: 1
            }).then((value) {
              return db.collection(FirestoreCollections.housingCooperative).doc("Pilvilinna").collection(FirestoreCollections.amenities).doc("saunas").collection("saunas").doc("sauna1").collection(FirestoreCollections.amenitiesReservations).add({
                FirestoreFields.reservationReserver: "A1",
                FirestoreFields.reservationWeekday: 3,
                FirestoreFields.reservationStartTime: 13.00,
                FirestoreFields.reservationEndTime: 14.00
              }).then((value) {return true;});
            });
          });
        });
      });
    }
}
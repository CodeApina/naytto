// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:naytto/src/constants/firestore_constants.dart';
// import 'package:naytto/src/features/authentication/domain/app_user.dart';

// class ApartmentBooking extends StatelessWidget {
//   final appUser = AppUser();

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<QuerySnapshot>(
//       future: FirebaseFirestore.instance
//           //gets booking_referenses from users apartment
//           .collection(FirestoreCollections.housingCooperative)
//           .doc(appUser.housingCooperative)
//           .collection('apartments')
//           .doc(appUser.apartmentId)
//           .collection('bookings')
//           .get(),
//       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return CircularProgressIndicator();
//         }

//         snapshot.data!.docs.forEach((DocumentSnapshot document) async {
//           Map<String, dynamic> data = document.data() as Map<String, dynamic>;
//           DocumentReference bookingReference =
//               data['booking_reference'] as DocumentReference;
//           String collectionName = bookingReference.parent.parent!.id;
//           String documentName = bookingReference.id;
//           if (documentName == "2") {
//             documentName = "Tiistai";
//           }
//           if (documentName == "7") {
//             documentName = "Sunnuntai";
//           }
//           // Gets the document in document-referense
//           DocumentSnapshot bookingSnapshot = await bookingReference.get();
//           if (bookingSnapshot.exists) {
//             Map<String, dynamic> bookingData =
//                 bookingSnapshot.data() as Map<String, dynamic>;

//             //goes true all the fields and prints if it has the right apartmentnumber
//             bookingData.forEach((key, value) {
//               if (value == appUser.apartmentId) {
//                 print('$collectionName  $documentName  $key:00 $value');
//               }
//             });
//           }
//         });

//         return SizedBox();
//       },
//     );
//   }
// }

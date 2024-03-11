// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:naytto/src/constants/firestore_constants.dart';

// typedef BookingsID = String;

// class Bookings {
//   const Bookings({
//     required this.id,
//     required this.apartmentID,
//     required this.day,
//     required this.time,
//     required this.type,
//     required this.amenityID,
//   });
//   final BookingsID id;
//   final String day;
//   final String time;
//   final String type;
//   final String amenityID;
//   final String apartmentID;

//   factory Bookings.fromMap(Map<String, dynamic> snapshot, BookingsID id) {
//     return Bookings(
//         id: id,
//         day: snapshot[FirestoreFields.bookingDay] as String,
//         time: snapshot[FirestoreFields.bookingTime] as String,
//         type: snapshot[FirestoreFields.bookingType] as String,
//         apartmentID: snapshot[FirestoreFields.bookingApartmentID] as String,
//         amenityID: snapshot[FirestoreFields.bookingID] as String);
//   }
//   // This method is not really in use, but it's necessary to use withConverter
//   //// for [FirestoreListView]
//   Map<String, dynamic> toMap() => {
//         'id': id,
//         FirestoreFields.bookingDay: day,
//         FirestoreFields.bookingTime: time,
//         FirestoreFields.bookingType: type,
//         FirestoreFields.bookingID: amenityID
//       };
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naytto/src/constants/firestore_constants.dart';

typedef BookingsID = String;

class Bookings {
  const Bookings({
    required this.id,
    required this.apartmentID,
    this.day,
    this.time,
    required this.type,
    this.amenityID,
    this.timestamp,
  });
  final BookingsID id;
  final String? day;
  final String? time;
  final String type;
  final String? amenityID;
  final String apartmentID;
  final Timestamp? timestamp;

  factory Bookings.fromMap(Map<String, dynamic> snapshot, BookingsID id) {
    return Bookings(
        id: id,
        day: snapshot[FirestoreFields.bookingDay] as String?,
        time: snapshot[FirestoreFields.bookingTime] as String?,
        type: snapshot[FirestoreFields.bookingType] as String,
        apartmentID: snapshot[FirestoreFields.bookingApartmentID] as String,
        timestamp: snapshot['timestamp'] as Timestamp?,
        amenityID: snapshot[FirestoreFields.bookingID] as String?);
  }
  // This method is not really in use, but it's necessary to use withConverter
  //// for [FirestoreListView]
  Map<String, dynamic> toMap() => {
        'id': id,
        FirestoreFields.bookingDay: day,
        FirestoreFields.bookingTime: time,
        FirestoreFields.bookingType: type,
        FirestoreFields.bookingID: amenityID,
        FirestoreFields.bookingApartmentID: apartmentID,
        'timestamp': timestamp
      };
}

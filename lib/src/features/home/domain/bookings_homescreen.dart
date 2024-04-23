import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:naytto/src/constants/firestore_constants.dart';

//  USED IN BOOKINGS_HOMESCREEN_REPOSITORY
typedef BookingsID = String;

class Bookings {
  const Bookings({
    required this.id,
    required this.apartmentID,
    required this.type,
    this.day,
    this.time,
    this.amenityID,
    this.timestamp,
    this.displayname,
  });
  final BookingsID id;
  final String apartmentID;
  final String type;
  final String? day;
  final String? time;
  final String? amenityID;
  final Timestamp? timestamp;
  final String? displayname;

  factory Bookings.fromMap(Map<String, dynamic> snapshot, BookingsID id) {
    return Bookings(
        id: id,
        day: snapshot[FirestoreFields.bookingDay] as String?,
        time: snapshot[FirestoreFields.bookingTime] as String?,
        type: snapshot[FirestoreFields.bookingType] as String,
        apartmentID: snapshot[FirestoreFields.bookingApartmentID] as String,
        timestamp: snapshot['timestamp'] as Timestamp?,
        displayname: snapshot[FirestoreFields.amenityDisplayName] as String?,
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
        FirestoreFields.amenityDisplayName: displayname,
        'timestamp': timestamp
      };
}

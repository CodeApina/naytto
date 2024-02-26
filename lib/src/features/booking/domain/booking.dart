import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:naytto/src/constants/firestore_constants.dart';

class Booking {
  Booking(
      {required this.bookingID,
      required this.apartmentID,
      required this.amenityID,
      required this.type,
      this.time,
      this.day,
      this.timestamp});

  // required
  final String bookingID;
  final String apartmentID;
  final String amenityID;
  final String type;

  // optional
  final String? time;
  final String? day;
  final Timestamp? timestamp;

  factory Booking.fromFirestore(Map<String, dynamic> snapshot, id) {
    return Booking(
      bookingID: id,
      apartmentID: snapshot[FirestoreFields.bookingApartmentID] as String,
      amenityID: snapshot[FirestoreFields.bookingID] as String,
      type: snapshot[FirestoreFields.bookingType] as String,
      time: snapshot[FirestoreFields.bookingTime] as String?,
      day: snapshot[FirestoreFields.bookingDay] as String?,
      timestamp: snapshot['timestamp'] as Timestamp?,
    );
  }

  Map<String, dynamic> toFirestore() {
    final Map<String, dynamic> firestoreData = {
      // These fields are always included
      FirestoreFields.bookingApartmentID: apartmentID,
      FirestoreFields.bookingID: amenityID,
      FirestoreFields.bookingType: type,
    };

    // These fields will only be included if they are not null
    if (timestamp != null) {
      firestoreData['timestamp'] = timestamp;
    }
    if (time != null) {
      firestoreData[FirestoreFields.bookingTime] = time;
    }
    if (day != null) {
      firestoreData[FirestoreFields.bookingDay] = day;
    }

    return firestoreData;
  }
}

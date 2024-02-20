import 'package:cloud_firestore/cloud_firestore.dart';

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
      apartmentID: snapshot['apartmentID'] as String,
      amenityID: snapshot['amenityID'] as String,
      type: snapshot['type'] as String,
      time: snapshot['time'] as String?,
      day: snapshot['day'] as String?,
      timestamp: snapshot['timestamp'] as Timestamp?,
    );
  }

  Map<String, dynamic> toFirestore() {
    final Map<String, dynamic> firestoreData = {
      // These fields are always included
      'apartmentID': apartmentID,
      'amenityID': amenityID,
      'type': type,
    };

    // These fields will only be included if they are not null
    if (timestamp != null) {
      firestoreData['timestamp'] = timestamp;
    }
    if (time != null) {
      firestoreData['time'] = time;
    }
    if (day != null) {
      firestoreData['day'] = day;
    }

    return firestoreData;
  }
}

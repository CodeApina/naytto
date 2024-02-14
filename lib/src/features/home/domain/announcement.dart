import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:naytto/src/constants/firestore_constants.dart';

typedef AnnouncementID = String;

// Class representing an Announcement
class Announcement {
  const Announcement(
      {required this.id,
      required this.body,
      required this.title,
      required this.timestamp,
      required this.urgency});
  final AnnouncementID id;
  final String body;
  final String title;
  final Timestamp timestamp;
  final int urgency;

  // Factory method to create an Announcement from a Map (firestore snapshot)
  // and an ID (firestore snapshot.id which is a documentID)
  factory Announcement.fromMap(
      Map<String, dynamic> snapshot, AnnouncementID id) {
    return Announcement(
        id: id,
        body: snapshot[FirestoreFields.announcementBody] as String,
        title: snapshot[FirestoreFields.announcementTitle] as String,
        timestamp: snapshot[FirestoreFields.announcementTimestamp] as Timestamp,
        urgency: snapshot[FirestoreFields.announcementUrgency] as int);
  }

  // This method is not really in use, but it's necessary to use withConverter
  //// for [FirestoreListView]
  Map<String, dynamic> toMap() => {
        'id': id,
        FirestoreFields.announcementBody: body,
        FirestoreFields.announcementTitle: title,
        FirestoreFields.announcementTimestamp: timestamp,
        FirestoreFields.announcementUrgency: urgency
      };
}

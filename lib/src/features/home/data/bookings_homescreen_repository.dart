import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naytto/src/constants/firestore_constants.dart';
import 'package:naytto/src/features/authentication/domain/app_user.dart';
import 'package:naytto/src/features/home/domain/announcement.dart';
import 'package:naytto/src/features/home/domain/bookings_homescreen.dart';

final apartmentsBookingsProvider = StreamProvider.autoDispose<List<Bookings>>(
  (ref) async* {
    final _firestore = FirebaseFirestore.instance;

    final String housingCooperativeName =
        ref.watch(AppUser().provider).housingCooperative;
    final String apartmentid = ref.watch(AppUser().provider).apartmentId;

    yield* _firestore
        .collection(FirestoreCollections.housingCooperative)
        .doc(housingCooperativeName)
        .collection(FirestoreCollections.bookings)
        .where('apartmentID', isEqualTo: apartmentid)
        // .where('type', isEqualTo: "sauna")
        // .orderBy('timestamp', descending: true)
        // .limit(2)

        // .snapshots()
        // .map((querySnapshot) => querySnapshot.docs
        //     .map((doc) => Bookings.fromMap(doc.data(), doc.id))
        //     .toList());

        //Chatgpt:s Wild sorting system
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => Bookings.fromMap(doc.data(), doc.id))
            .toList()
          ..sort((a, b) {
            if (a.type == "sauna" && b.type == "laundry") {
              return -1; // "sauna" comes before "laundry"
            } else if (a.type == "laundry" && b.type == "sauna") {
              return 1;
            } else if (a.type == "laundry" && b.type == "laundry") {
              // "laundry"-types sortet by timestamp if available
              return (a.timestamp != null && b.timestamp != null)
                  ? a.timestamp!.compareTo(b.timestamp!)
                  : 0;
            } else {
              return 0;
            }
          }));
  },
);

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naytto/src/constants/firestore_constants.dart';
import 'package:naytto/src/features/authentication/domain/app_user.dart';
import 'package:naytto/src/features/home/domain/announcement.dart';

final announcementsProvider = StreamProvider.autoDispose<List<Announcement>>(
  (ref) async* {
    final _firestore = FirebaseFirestore.instance;

    final String housingCooperativeName =
        ref.watch(AppUser().provider).housingCooperative;

    yield* _firestore
        .collection(FirestoreCollections.housingCooperative)
        .doc(housingCooperativeName)
        .collection(FirestoreCollections.announcements)
        .orderBy('timestamp', descending: true)
        .limit(2)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => Announcement.fromMap(doc.data(), doc.id))
            .toList());
  },
);

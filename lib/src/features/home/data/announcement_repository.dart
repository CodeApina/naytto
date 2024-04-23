import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naytto/src/constants/firestore_constants.dart';
import 'package:naytto/src/features/authentication/domain/app_user.dart';
import 'package:naytto/src/features/home/domain/announcement.dart';

// Provider for fetching the latest 2 announcements for the home screen
final announcementsHomeScreenProvider =
    StreamProvider.autoDispose<List<Announcement>>(
  (ref) async* {
    final firestore = FirebaseFirestore.instance;

    final String housingCooperativeName =
        ref.watch(AppUser().provider).housingCooperative;

    yield* firestore
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

// Provider for fetching all announcements
final allAnnouncementsProvider = StreamProvider.autoDispose<List<Announcement>>(
  (ref) async* {
    final firestore = FirebaseFirestore.instance;

    final String housingCooperativeName =
        ref.watch(AppUser().provider).housingCooperative;

    yield* firestore
        .collection(FirestoreCollections.housingCooperative)
        .doc(housingCooperativeName)
        .collection(FirestoreCollections.announcements)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => Announcement.fromMap(doc.data(), doc.id))
            .toList());
  },
);

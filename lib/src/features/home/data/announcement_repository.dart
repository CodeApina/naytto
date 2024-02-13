import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naytto/src/constants/firestore_constants.dart';
import 'package:naytto/src/features/authentication/domain/app_user.dart';
import 'package:naytto/src/features/authentication/domain/app_user_new.dart';
import 'package:naytto/src/features/home/domain/announcement.dart';

class AnnouncementsRepository {
  // Constructor for AnnouncementsRepository
  AnnouncementsRepository(this._firestore, this.housingCooperativeName);
  final FirebaseFirestore _firestore;
  final HousingCooperativeName housingCooperativeName;

  //// Method to create a query for announcements to be used by a [FirestoreListView]
  // Query<Announcement> announcementsQuery() {
  //   print('Announcement repo fetched');
  //   return _firestore
  //       .collection(FirestoreCollections.housingCooperative)
  //       // Not yet working
  //       // .doc(_appUser.housingCooperative)
  //       .doc(housingCooperativeName)
  //       // .doc(_appUser.housingCooperative)
  //       .collection(FirestoreCollections.announcements)
  //       .withConverter(
  //         fromFirestore: (snapshot, _) {
  //           return Announcement.fromMap(snapshot.data()!, snapshot.id);
  //         },
  //         // toFirestore is not actually used but needs to be here
  //         // because it is a required parameter for query
  //         toFirestore: (announcement, _) => announcement.toMap(),
  //       )
  //       .orderBy(FirestoreFields.announcementTimestamp, descending: false);
  // }
}

final announcementsRepositoryProvider =
    Provider.autoDispose<AnnouncementsRepository>((ref) {
  final housingCooperativeNameAsync = ref.watch(housingCooperativeNameProvider);

  if (housingCooperativeNameAsync is AsyncLoading) {
    // If the future is still loading, return a placeholder repository or null
    return AnnouncementsRepository(FirebaseFirestore.instance,
        'placeholder'); // or return a placeholder repository instance
  }

  if (housingCooperativeNameAsync is AsyncError) {
    // If the future completes with an error, handle it appropriately
    throw Exception(
        "Failed to obtain housing cooperative name: ${housingCooperativeNameAsync.error}");
  }

  // If the future completes successfully, return the repository
  final housingCooperativeName = housingCooperativeNameAsync.value!;
  return AnnouncementsRepository(
      FirebaseFirestore.instance, housingCooperativeName);
});

final announcementsProvider =
    StreamProvider.autoDispose<List<Announcement>>((ref) async* {
  final _firestore = FirebaseFirestore.instance;

  final String housingCooperativeName =
      await ref.watch(housingCooperativeNameProvider.future);

  print('announcement stream activated');
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
});

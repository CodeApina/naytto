import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naytto/src/constants/firestore_constants.dart';
import 'package:naytto/src/features/authentication/domain/app_user.dart';
import 'package:naytto/src/features/home/domain/announcement.dart';

class AnnouncementsRepository {
  // Constructor for AnnouncementsRepository
  AnnouncementsRepository(this._firestore, this._appUser);
  final FirebaseFirestore _firestore;
  final AppUser _appUser;

  //// Method to create a query for announcements to be used by a [FirestoreListView]
  Query<Announcement> announcementsQuery() {
    return _firestore
        .collection(FirestoreCollections.housingCooperative)

        // Not yet working
        // .doc(_appUser.housingCooperative)
        .doc("Pilvilinna")
        .collection(FirestoreCollections.announcements)
        .withConverter(
          fromFirestore: (snapshot, _) {
            return Announcement.fromMap(snapshot.data()!, snapshot.id);
          },
          // toFirestore is not actually used but needs to be here
          // because it is a required parameter for query
          toFirestore: (announcement, _) => announcement.toMap(),
        )
        .orderBy(FirestoreFields.announcementTimestamp, descending: false);
  }
}

// Provider for AnnouncementsRepository
final announcementsRepositoryProvider =
    Provider<AnnouncementsRepository>((ref) {
  final appUserProvider = ChangeNotifierProvider((ref) => AppUser());
  final appUser = ref.watch(appUserProvider);
  return AnnouncementsRepository(FirebaseFirestore.instance, appUser);
});

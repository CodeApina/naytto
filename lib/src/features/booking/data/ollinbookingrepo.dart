import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:naytto/src/constants/firestore_constants.dart';
import 'package:naytto/src/features/authentication/domain/app_user.dart';
import 'package:naytto/src/features/booking/domain/ollinsaunabookings.dart';

final saunaDataStreamProvider = StreamProvider<List<Ollinsaunabookings>>((ref) {
  final String housingCooperativeName =
      ref.watch(AppUser().provider).housingCooperative;
  DocumentReference docRef = FirebaseFirestore.instance
      .collection(FirestoreCollections.housingCooperative)
      .doc(housingCooperativeName)
      .collection(FirestoreCollections.saunas)
      .doc(ref.watch(selectedSaunaID));
  return fetchSaunaDataStream(docRef);
});

// default sauna for saunaDataStreamProvider & dropdownmenu  and state management of dropdownmenu selection in sauna_screen
final selectedSaunaID = StateProvider<String?>((ref) {
  final saunaIdsAsyncValue = ref.watch(getSaunasProvider);

  return saunaIdsAsyncValue.when(
    data: (saunaIds) {
      if (saunaIds.isNotEmpty) {
        return saunaIds[0];
      }
      return null;
    },
    loading: () => null,
    error: (_, __) => null,
  );
});
// query for saunas
final getSaunasProvider = FutureProvider<List<String>>((ref) async {
  final String housingCooperativeName =
      ref.watch(AppUser().provider).housingCooperative;
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(FirestoreCollections.housingCooperative)
        .doc(housingCooperativeName)
        .collection(FirestoreCollections.saunas)
        .get();

    List<String> saunaIds = [];

    querySnapshot.docs.forEach((doc) {
      saunaIds.add(doc.id);
    });

    return saunaIds;
  } catch (e) {
    print("error: $e");
    return [];
  }
});

// not in use at this time
Future<void> checkForNewSaunas(WidgetRef ref) async {
  final String housingCooperativeName =
      ref.watch(AppUser().provider).housingCooperative;
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection(FirestoreCollections.housingCooperative)
      .doc(housingCooperativeName)
      .collection(FirestoreCollections.saunas)
      .get();

  List<String> newSaunaIds = [];
  querySnapshot.docs.forEach((doc) {
    newSaunaIds.add(doc.id);
  });

  final currentSaunaIds = ref.watch(getSaunasProvider);

  // checks if the new list of saunas is different than the old one.
  currentSaunaIds.when(
    data: (saunas) {
      if (!ListEquality().equals(saunas, newSaunaIds)) {
        ref.refresh(getSaunasProvider);
      }
    },
    loading: () {},
    error: (_, __) {},
  );
}

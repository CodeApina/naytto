import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naytto/src/constants/firestore_constants.dart';
import 'package:naytto/src/features/authentication/data/firebase_auth_repository.dart';

typedef HousingCooperativeName = String;

final housingCooperativeNameProvider =
    AutoDisposeFutureProvider<HousingCooperativeName>((ref) async {
  final uid = ref.watch(firebaseAuthProvider).currentUser!.uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final response =
      await _firestore.collection(FirestoreCollections.users).doc(uid).get();

  final data = response.data();

  final HousingCooperativeName cooperative =
      data![FirestoreFields.usersHousingCooperative];
  return cooperative;
});

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
      .collection('saunas')
      .doc('ollintestisauna');
  print(docRef);
  return fetchSaunaDataStream(docRef);
});

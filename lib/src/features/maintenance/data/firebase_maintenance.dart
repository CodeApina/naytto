

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naytto/src/constants/firestore_constants.dart';
import 'package:naytto/src/features/authentication/domain/app_user.dart';
import 'package:naytto/src/features/maintenance/domain/maintenance.dart';

  final maintenanceStreamProvider = StreamProvider.autoDispose<List<Maintenance>>((ref) async*{
    final _firestore = FirebaseFirestore.instance;
    final String housingCooperativeName = ref.watch(AppUser().provider).housingCooperative;
    final String apartmentID = ref.watch(AppUser().provider).apartmentId;
    yield* _firestore
    .collection(FirestoreCollections.housingCooperative)
    .doc(housingCooperativeName)
    .collection(FirestoreCollections.maintenance)
    .where(FirestoreFields.maintenanceApartmentNumber, isEqualTo: apartmentID)
    .snapshots()
    .map((querySnapshot) {
      final documents = querySnapshot.docs;
      final maintenances = <Maintenance>[];
      for(var doc in documents){
        final maintenance = Maintenance.fromFirestore(doc.data(), doc.id);
        maintenances.add(maintenance);
      }
      return maintenances.take(maintenances.length).toList();
    });
  },);
  
  void storeTicketToFirestore(maintenanceMap) async{
    final _firestore = FirebaseFirestore.instance;
    await _firestore
    .collection(FirestoreCollections.housingCooperative)
    .doc(AppUser().housingCooperative)
    .collection(FirestoreCollections.maintenance)
    .add(maintenanceMap);
  }

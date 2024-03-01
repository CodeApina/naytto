import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:naytto/src/constants/firestore_constants.dart';
import 'package:naytto/src/features/authentication/domain/app_user.dart';
import 'package:naytto/src/features/booking/domain/amenity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'amenities_repository.g.dart';

class AmenitiesRepository {
  const AmenitiesRepository(this._firestore);
  final FirebaseFirestore _firestore;

  Query<Amenity> queryAmenities(
      String housingCooperative, String collectionName) {
    Query<Amenity> query = _firestore
        .collection(FirestoreCollections.housingCooperative)
        .doc(housingCooperative)
        .collection(collectionName)
        .withConverter<Amenity>(
          fromFirestore: (snapshot, _) =>
              Amenity.fromMap(snapshot.data()!, snapshot.id),
          toFirestore: (amenity, _) => amenity.toMap(),
        );
    return query;
  }

  Future<List<Amenity>> fetchAmenities(
      String housingCooperative, String collectionName) async {
    final amenities =
        await queryAmenities(housingCooperative, collectionName).get();
    return amenities.docs.map((doc) => doc.data()).toList();
  }
}

@Riverpod(keepAlive: true)
AmenitiesRepository amenitiesRepository(AmenitiesRepositoryRef ref) {
  return AmenitiesRepository(FirebaseFirestore.instance);
}

@riverpod
Future<List<Amenity>> amenitiesList(
    AmenitiesListRef ref, String collectionName) {
  final user = ref.watch(AppUser().provider);
  final housingCooperative = user.housingCooperative;
  final repository = ref.watch(amenitiesRepositoryProvider);
  return repository.fetchAmenities(housingCooperative, collectionName);
}

import 'package:naytto/src/constants/firestore_constants.dart';

// Amenity class representing a facility or service
class Amenity {
  Amenity({
    required this.amenityID,
    required this.displayName,
    required this.availableFrom,
    required this.availableTo,
    required this.outOfService,
  });
  final String amenityID;
  final String displayName;
  final String availableFrom;
  final String availableTo;
  final bool outOfService;

  factory Amenity.fromMap(Map<String, dynamic> snapshot, String id) {
    return Amenity(
      amenityID: id,
      displayName: snapshot[FirestoreFields.amenityDisplayName] as String,
      availableFrom: snapshot[FirestoreFields.amenityAvailableFrom] as String,
      availableTo: snapshot[FirestoreFields.amenityAvailableTo] as String,
      outOfService: snapshot[FirestoreFields.amenityOutOfService] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      FirestoreFields.amenityID: amenityID,
      FirestoreFields.amenityDisplayName: displayName,
      FirestoreFields.amenityAvailableFrom: availableFrom,
      FirestoreFields.amenityAvailableTo: availableTo,
      FirestoreFields.amenityOutOfService: outOfService,
    };
  }
}

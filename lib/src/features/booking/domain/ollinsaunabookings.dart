import 'package:naytto/src/constants/firestore_constants.dart';

// USED IN  OLLINSAUNABOOKINGREPO

typedef OllinsaunabookingsID = String;

class Ollinsaunabookings {
  const Ollinsaunabookings({
    required this.id,
    required this.availableFrom,
    required this.availableTo,
    required this.displayName,
    required this.fields,
    required this.bookingPath,
  });

  final OllinsaunabookingsID id;
  final int availableFrom;
  final int availableTo;
  final String displayName;
  final Map<String, Map<String, dynamic>> fields;
  final BookingPath bookingPath;

  factory Ollinsaunabookings.fromMap(
    Map<String, dynamic> snapshot,
    OllinsaunabookingsID id,
  ) {
    Map<String, Map<String, dynamic>> fields = {};
    BookingPath bookingPath = BookingPath();

    for (String key in snapshot.keys) {
      if (snapshot[key] is Map<String, dynamic>) {
        Map<String, dynamic> innerMap = snapshot[key];
        Map<String, dynamic> innerFields = {};

        for (String innerKey in innerMap.keys) {
          if (innerMap[innerKey] is Map<String, dynamic>) {
            Map<String, dynamic> innerInnerMap = innerMap[innerKey];

            innerFields[innerKey] = {
              'apartmentID': innerInnerMap['apartmentID'] as String,
              'available': innerInnerMap['available'] as bool,
            };
          }
        }

        fields[key] = innerFields;
        bookingPath.addPath(key);
      }
    }
    print('Fields: $fields');
    return Ollinsaunabookings(
      id: id,
      availableFrom: snapshot[FirestoreFields.amenityAvailableFrom] as int,
      availableTo: snapshot[FirestoreFields.amenityAvailableTo] as int,
      displayName: snapshot[FirestoreFields.amenityDisplayName] as String,
      fields: fields,
      bookingPath: bookingPath,
    );
  }
}

class BookingPath {
  final List<String> _paths = [];

  void addPath(String path) {
    _paths.add(path);
  }

  List<String> get paths => List<String>.unmodifiable(_paths);
}

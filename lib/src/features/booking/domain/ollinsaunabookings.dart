import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naytto/src/constants/firestore_constants.dart';
import 'package:naytto/src/features/authentication/domain/app_user.dart';
// import 'package:riverpod/riverpod.dart';

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

Stream<List<Ollinsaunabookings>> fetchSaunaDataStream(
  DocumentReference docRef,
) {
  return docRef.snapshots().map((snapshot) {
    List<Ollinsaunabookings> bookingsList = [];
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    Ollinsaunabookings booking = Ollinsaunabookings.fromMap(data, snapshot.id);
    bookingsList.add(booking);
    return bookingsList;
  }).handleError((error) {
    print('Virhe haettaessa dataa Firestoresta: $error');
    return [];
  });
}

// changes saunas availability
final saunaDataUpdateProvider = Provider((ref) => SaunaDataUpdate(ref));

class SaunaDataUpdate {
  // able to read appuser with this.
  final ProviderRef ref;

  SaunaDataUpdate(this.ref);

  Future<void> updateSaunaData(
    //these come from sauna_screen buttons
    String docid,
    String fieldName,
    String time,
    bool available,
    String weekDay,
    String displayname,
  ) async {
    // cant change falue of booked time
    if (available == false) return;
    if (await checkIfBookingExistsAndDeleteBookingAndChangeSaunaAvailability()) {
      try {
        final appUser = ref.read(AppUser().provider);
        final newValue = available ? false : true;

        Map<String, dynamic> newBooking = {
          FirestoreFields.bookingApartmentID: appUser.apartmentId,
          FirestoreFields.bookingDay: weekDay,
          FirestoreFields.bookingTime: time,
          FirestoreFields.bookingAmenityID: docid,
          FirestoreFields.bookingType: 'sauna',
          FirestoreFields.amenityDisplayName: displayname,
        };
        // change availability
        await FirebaseFirestore.instance
            .collection(FirestoreCollections.housingCooperative)
            .doc(appUser.housingCooperative)
            .collection('saunas')
            .doc(docid)
            .update({
          '$fieldName.$time.available': newValue,
          '$fieldName.$time.apartmentID': appUser.apartmentId,
        });

        //make a new booking to bookings
        await FirebaseFirestore.instance
            .collection(FirestoreCollections.housingCooperative)
            .doc(appUser.housingCooperative)
            .collection(FirestoreCollections.bookings)
            .add(newBooking);
      } catch (e) {
        throw Exception('Error updating sauna data: $e');
      }
    }
  }

  Future<bool>
      checkIfBookingExistsAndDeleteBookingAndChangeSaunaAvailability() async {
    try {
      final appUser = ref.read(AppUser().provider);
      final docref = FirebaseFirestore.instance
          .collection(FirestoreCollections.housingCooperative)
          .doc(appUser.housingCooperative)
          .collection(FirestoreCollections.bookings);

      final querySnapshot = await docref
          .where(FirestoreFields.bookingApartmentID,
              isEqualTo: appUser.apartmentId)
          .where('type', isEqualTo: 'sauna')
          .get();

      // used to delete old booking from bookings
      //& change the availability of saunas to true according to old booking
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          Map<String, dynamic> data = doc.data();
          String day = data[FirestoreFields.bookingDay];
          String time = data[FirestoreFields.bookingTime];
          String docId = data[FirestoreFields.bookingAmenityID];
          bool newValue = true;
          if (day == 'Monday') day = "1";
          if (day == 'Tuesday') day = "2";
          if (day == 'Wednesday') day = "3";
          if (day == 'Thursday') day = "4";
          if (day == 'Friday') day = "5";
          if (day == 'Saturday') day = "6";
          if (day == 'Sunday') day = "7";

          // changes saunas availability to true
          await FirebaseFirestore.instance
              .collection(FirestoreCollections.housingCooperative)
              .doc(appUser.housingCooperative)
              .collection('saunas')
              .doc(docId)
              .update({
            '$day.$time.available': true,
            '$day.$time.apartmentID': "",
          });
        }
        // deletes old bookings from sauna
        for (var doc in querySnapshot.docs) {
          await doc.reference.delete();
        }
      }

      return true;
    } catch (e) {
      throw Exception('Error checking data: $e');
    }
  }
}

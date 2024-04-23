import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:naytto/src/constants/firestore_constants.dart';
import 'package:naytto/src/features/authentication/domain/app_user.dart';
import 'package:naytto/src/features/booking/domain/ollinsaunabookings.dart';
// USED IN SAUNA_SCREEN

// saunas data
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

// default sauna for saunaDataStreamProvider & dropdownmenu and state management of dropdownmenu selection in sauna_screen
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
            '$day.$time.available': newValue,
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

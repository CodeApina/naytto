import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:naytto/src/constants/firestore_constants.dart';
import 'package:naytto/src/features/authentication/domain/app_user.dart';
import 'package:naytto/src/features/booking/domain/booking.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'new_booking_repository.g.dart';

class NewBookingRepository {
  const NewBookingRepository(this._firestore);
  final FirebaseFirestore _firestore;

  // Query bookings based on various parameters
  Query<Booking> queryBookings(
      {required String housingCooperative,
      String? amenityID,
      String? apartmentID}) {
    Query<Booking> query = _firestore
        .collection(FirestoreCollections.housingCooperative)
        .doc(housingCooperative)
        .collection(FirestoreCollections.bookings)
        .withConverter<Booking>(
          fromFirestore: (snapshot, _) =>
              Booking.fromFirestore(snapshot.data()!, snapshot.id),
          toFirestore: (booking, _) => booking.toFirestore(),
        );

    // Filter by amenityID if provided
    if (amenityID != null) {
      query =
          query.where(FirestoreFields.bookingAmenityID, isEqualTo: amenityID);
    }
    // Filter by apartmentID if provided
    if (apartmentID != null) {
      query = query.where(FirestoreFields.bookingApartmentID,
          isEqualTo: apartmentID);
    }
    return query;
  }

  // Query bookings within a specific time range
  Query<Booking> queryBookingswithinDate(
      {required String housingCooperative,
      required String amenityID,
      required DateTime date}) {
    // Get today's date without considering the time
    DateTime selectedDate = date;
    DateTime startOfDay = DateTime(selectedDate.year, selectedDate.month,
        selectedDate.day); // Start of today
    DateTime endOfDay = startOfDay
        .add(const Duration(days: 1))
        .subtract(const Duration(milliseconds: 1)); // End of today

    // Convert start and end of day to Firestore Timestamp objects
    Timestamp startTimestamp = Timestamp.fromDate(startOfDay);
    Timestamp endTimestamp = Timestamp.fromDate(endOfDay);

    // This required a composite index to be made "https://firebase.google.com/docs/firestore/query-data/index-overview#composite_indexes"
    // which Firestore created automatically when trying to run the query
    Query<Booking> query = _firestore
        .collection(FirestoreCollections.housingCooperative)
        .doc(housingCooperative)
        .collection(FirestoreCollections.bookings)
        .where(FirestoreFields.bookingAmenityID, isEqualTo: amenityID)
        .where(FirestoreFields.bookingTimestamp,
            isGreaterThanOrEqualTo: startTimestamp)
        .where(FirestoreFields.bookingTimestamp,
            isLessThanOrEqualTo: endTimestamp)
        .withConverter<Booking>(
          fromFirestore: (snapshot, _) =>
              Booking.fromFirestore(snapshot.data()!, snapshot.id),
          toFirestore: (booking, _) => booking.toFirestore(),
        );

    return query;
  }

  // Add booking
  Future<void> addBooking(
      {required String housingCooperative, required Booking booking}) {
    return _firestore
        .collection(FirestoreCollections.housingCooperative)
        .doc(housingCooperative)
        .collection(FirestoreCollections.bookings)
        .add(booking.toFirestore());
  }

  // Delete booking
  Future<void> deleteBooking(
      {required String housingCooperative, required String bookingID}) {
    return _firestore
        .collection(FirestoreCollections.bookings)
        .doc(bookingID)
        .delete();
  }

  // Update booking
  Future<void> updateBooking(
      {required String housingCooperative,
      required String bookingID,
      required Booking booking}) {
    return _firestore
        .collection(FirestoreCollections.housingCooperative)
        .doc(housingCooperative)
        .collection(FirestoreCollections.bookings)
        .doc(bookingID)
        .update(booking.toFirestore());
  }

  // read
  // Stream<List<Booking>> watchBookings(
  //     {required String housingCooperative,
  //     String? amenityID,
  //     String? apartmentID}) {
  //   return queryBookings(
  //           housingCooperative: housingCooperative,
  //           amenityID: amenityID,
  //           apartmentID: apartmentID)
  //       .snapshots()
  //       .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  // }

  // Stream of bookings for a specific day
  Stream<List<Booking>> watchBookings(
      {required String housingCooperative,
      required String amenityID,
      required DateTime date}) {
    return queryBookingswithinDate(
            housingCooperative: housingCooperative,
            amenityID: amenityID,
            date: date)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}

// Riverpod provider to access this repository and it's methods elsewhere
@Riverpod(keepAlive: true)
NewBookingRepository newBookingRepository(NewBookingRepositoryRef ref) {
  return NewBookingRepository(FirebaseFirestore.instance);
}

// Riverpod provider for a stream of bookings for a certain day
@riverpod
Stream<List<Booking>> bookingsForDateStream(
    BookingsForDateStreamRef ref, String amenityID, DateTime date) {
  final user = ref.watch(AppUser().provider);
  final housingCooperative = user.housingCooperative;
  final repository = ref.watch(newBookingRepositoryProvider);
  return repository.watchBookings(
      housingCooperative: housingCooperative, amenityID: amenityID, date: date);
}

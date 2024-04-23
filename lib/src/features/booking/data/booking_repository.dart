import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:naytto/src/constants/firestore_constants.dart';
import 'package:naytto/src/features/authentication/domain/app_user.dart';
import 'package:naytto/src/features/booking/domain/booking.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'booking_repository.g.dart';

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
    // Get today's date as a day, ignore what the clock is
    DateTime selectedDate = date;
    DateTime startOfDay =
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    DateTime endOfDay = startOfDay
        .add(const Duration(days: 1))
        .subtract(const Duration(milliseconds: 1));

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

  // Query bookings for a specific user using their apartmentID
  Query<Booking> queryBookingsForUser(
      {required String housingCooperative, required String apartmentID}) {
    Query<Booking> query = _firestore
        .collection(FirestoreCollections.housingCooperative)
        .doc(housingCooperative)
        .collection(FirestoreCollections.bookings)
        .where(FirestoreFields.bookingApartmentID, isEqualTo: apartmentID)
        .orderBy('timestamp', descending: true)
        .withConverter<Booking>(
          fromFirestore: (snapshot, _) =>
              Booking.fromFirestore(snapshot.data()!, snapshot.id),
          toFirestore: (booking, _) => booking.toFirestore(),
        );
    return query;
  }

  // Returns a stream of lists of bookings for a specific user identified by their housing cooperative and apartment ID.
  Stream<List<Booking>> watchBookingsForUser(
      {required String housingCooperative, required String apartmentID}) {
    return queryBookingsForUser(
            housingCooperative: housingCooperative, apartmentID: apartmentID)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}

// Riverpod provider to access this repository and it's methods elsewhere
@Riverpod(keepAlive: true)
NewBookingRepository bookingRepository(BookingRepositoryRef ref) {
  return NewBookingRepository(FirebaseFirestore.instance);
}

// Riverpod provider for a stream of bookings for a certain day
@riverpod
Stream<List<Booking>> bookingsForDateStream(
    BookingsForDateStreamRef ref, String amenityID, DateTime date) {
  final user = ref.watch(AppUser().provider);
  final housingCooperative = user.housingCooperative;
  final repository = ref.watch(bookingRepositoryProvider);
  return repository.watchBookings(
      housingCooperative: housingCooperative, amenityID: amenityID, date: date);
}

// Riverpod provider for the stream of all bookings for a specific user
@riverpod
Stream<List<Booking>> allBookingsForUserStream(
    AllBookingsForUserStreamRef ref) {
  final user = ref.watch(AppUser().provider);
  final housingCooperative = user.housingCooperative;
  final repository = ref.watch(bookingRepositoryProvider);
  return repository.watchBookingsForUser(
      housingCooperative: housingCooperative, apartmentID: user.apartmentId);
}

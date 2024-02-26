import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naytto/src/constants/firestore_constants.dart';
import 'package:naytto/src/features/authentication/domain/app_user.dart';
import 'package:naytto/src/features/booking/domain/booking.dart';

// Access the bookings notifier elsewhere in code via this provider and use it's internal methods
// Returns an AsyncValue<List<Booking>>
final userBookingsProvider = AsyncNotifierProvider.family
    .autoDispose<UserBookings, List<Booking>, String>(() {
  return UserBookings();
});

// TODO: Should probably get converted to a StreamNotifier so the UI is up to date with multiple users
// Right now the screen would not refresh if another user makes changes to the collection

// Holds the state of the bookings for the user
// and provides methods to fetch/add/delete/update them
// It's a notifier because it holds a state
// It's autodispose to prevent memory leaks
// It's family because it takes an argument for booking types
// It's Async because it returns a future

class UserBookings
    extends AutoDisposeFamilyAsyncNotifier<List<Booking>, String> {
  // Build method
  @override
  Future<List<Booking>> build(String arg) async {
    return _fetchBookings(arg);
  }

  // Fetch all bookings for the user
  // param requirement is a booking type like sauna, laundry, etc
  Future<List<Booking>> _fetchBookings(String bookingType) async {
    final AppUser user = ref.watch(AppUser().provider);
    final String housingCooperative = user.housingCooperative;
    final String apartmentID = user.apartmentId;

    // Query
    final snapshot = await FirebaseFirestore.instance
        .collection(FirestoreCollections.housingCooperative)
        .doc(housingCooperative)
        .collection(FirestoreCollections.bookings)
        .where(FirestoreFields.bookingApartmentID, isEqualTo: apartmentID)
        .where(FirestoreFields.bookingType, isEqualTo: bookingType)
        .get();

    // Access snapshot data and create a booking object from each document
    // and add it to the list
    final List<Booking> bookings = snapshot.docs.map((doc) {
      final data = doc.data();
      final id = doc.id;
      return Booking.fromFirestore(data, id);
    }).toList();

    // Return the list of bookings
    return bookings;
  }

  // Add a booking and refresh state
  Future<void> addBooking(Booking booking) async {
    final AppUser user = ref.watch(AppUser().provider);
    final String housingCooperative = user.housingCooperative;
    String bookingType = booking.type;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await FirebaseFirestore.instance
          .collection(FirestoreCollections.housingCooperative)
          .doc(housingCooperative)
          .collection(FirestoreCollections.bookings)
          .add(booking.toFirestore());
      return _fetchBookings(bookingType);
    });
  }

  // Delete a booking and refresh state
  Future<void> deleteBooking(String bookingID, String bookingType) async {
    final AppUser user = ref.watch(AppUser().provider);
    final String housingCooperative = user.housingCooperative;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await FirebaseFirestore.instance
          .collection(FirestoreCollections.housingCooperative)
          .doc(housingCooperative)
          .collection(FirestoreCollections.bookings)
          .doc(bookingID)
          .delete();
      return _fetchBookings(bookingType);
    });
  }

  // Update a booking and refresh state
  Future<void> updateBooking(String bookingID, Booking booking) async {
    final AppUser user = ref.watch(AppUser().provider);
    final String housingCooperative = user.housingCooperative;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await FirebaseFirestore.instance
          .collection(FirestoreCollections.housingCooperative)
          .doc(housingCooperative)
          .collection(FirestoreCollections.bookings)
          .doc(bookingID)
          .update(booking.toFirestore());
      return _fetchBookings(booking.type);
    });
  }
}

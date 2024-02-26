import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naytto/src/features/booking/data/booking_repository.dart';
import 'package:naytto/src/features/booking/domain/booking.dart';
import 'package:naytto/src/utilities/timestamp_formatter.dart';

class LaundryScreen extends ConsumerWidget {
  const LaundryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookings = ref.watch(
      userBookingsProvider('laundry'),
    );
    return ColorfulSafeArea(
      color: Colors.white,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Laundry booking',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                bookings.when(
                    data: (bookings) {
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: bookings.length,
                          itemBuilder: (context, index) {
                            final booking = bookings[index];
                            return Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(booking.type),
                                  Text('machine:${booking.amenityID}'),
                                  Text(
                                    booking.timestamp != null
                                        ? formatTimestamp(
                                            booking.timestamp!,
                                          )
                                        : 'No timestamp available',
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                  // DELETE BOOKING
                                  TextButton(
                                    onPressed: () {
                                      ref
                                          .read(userBookingsProvider('laundry')
                                              .notifier)
                                          .deleteBooking(
                                              booking.bookingID, booking.type);
                                    },
                                    child: const Text('delete'),
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    error: (error, stackTrace) => Text('$error'),
                    loading: () => const CircularProgressIndicator()),
                TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('add booking'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                  onPressed: () {
                                    ref
                                        .read(userBookingsProvider('laundry')
                                            .notifier)
                                        .addBooking(Booking(
                                            bookingID: '',
                                            apartmentID: 'A1',
                                            amenityID: 'laundry1',
                                            timestamp: Timestamp.now(),
                                            type: 'laundry'));
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Update'))
                            ],
                          );
                        },
                      );
                    },
                    child: const Text('add booking'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Timestamp generateRandomTimestamp() {
  // Get the current timestamp
  Timestamp now = Timestamp.now();

  // Get the maximum timestamp (1 month away from now)
  Timestamp maxTimestamp = Timestamp(now.seconds + 30 * 24 * 60 * 60, 0);

  // Generate a random number of milliseconds within the range of now to maxTimestamp
  Random random = Random();
  int randomMilliseconds = random.nextInt(maxTimestamp.seconds - now.seconds);

  // Create a new timestamp by adding the random number of milliseconds to the current timestamp
  Timestamp randomTimestamp = Timestamp(
    now.seconds + randomMilliseconds,
    now.nanoseconds,
  );

  return randomTimestamp;
}

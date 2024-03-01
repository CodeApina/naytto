import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naytto/src/features/booking/data/amenities_repository.dart';
import 'package:naytto/src/features/booking/data/booking_repository.dart';
import 'package:naytto/src/features/booking/domain/booking.dart';
import 'package:naytto/src/utilities/timestamp_formatter.dart';

class SelectedAmenityNameNotifier extends StateNotifier<String?> {
  SelectedAmenityNameNotifier() : super(null);

  void setSelectedAmenity(String? amenityID) {
    state = amenityID;
  }
}

final selectedAmenityProvider =
    StateNotifierProvider<SelectedAmenityNameNotifier, String?>((ref) {
  return SelectedAmenityNameNotifier();
});

class LaundryScreen extends ConsumerWidget {
  const LaundryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final amenities = ref.watch(AmenitiesListProvider('laundry'));
    final selectedAmenity = ref.watch(selectedAmenityProvider);
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
                amenities.when(
                    data: (amenities) {
                      return Column(
                        children: [
                          const SizedBox(
                            height: 80,
                          ),
                          const Text('Select laundry machine'),
                          DropdownButton(
                              value: selectedAmenity,
                              items: amenities.map((amenity) {
                                return DropdownMenuItem(
                                    value: amenity.amenityID,
                                    child: Text(
                                      amenity.displayName,
                                    ));
                              }).toList(),
                              onChanged: (String? selectedAmenity) {
                                ref
                                    .read(selectedAmenityProvider.notifier)
                                    .setSelectedAmenity(selectedAmenity);
                              }),
                          const Text('You have selected:'),
                        ],
                      );
                    },
                    error: (error, stackTrace) => Text('$error'),
                    loading: () {
                      return const Center(child: CircularProgressIndicator());
                    }),
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

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naytto/src/features/booking/data/new_booking_repository.dart';
import 'package:naytto/src/features/booking/domain/booking.dart';
import 'package:naytto/src/routing/app_router.dart';
import 'package:naytto/src/utilities/capitalizer.dart';
import 'package:naytto/src/utilities/timestamp_formatter.dart';

class MyBookingsScreen extends ConsumerWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              ref.read(goRouterProvider).pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
            )),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'My bookings',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      body: const ColorfulSafeArea(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [BookingsList()],
          ),
        ),
      ),
    );
  }
}

class BookingsList extends ConsumerWidget {
  const BookingsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookings = ref.watch(allBookingsForUserStreamProvider);
    return Container(
      child: bookings.when(
          data: (bookings) {
            return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 10),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(128, 238, 238, 238),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              (booking.type == 'sauna')
                                  ? Icon(Icons.shower)
                                  : Icon(Icons.local_laundry_service_sharp),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                capitalizer(booking.type),
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                              SizedBox(
                                width: 40,
                              ),
                              Text(
                                booking.day != null
                                    ? '   ${booking.day}, ${booking.time}:00'
                                    : formatTimestampWithHHmm(
                                        booking.timestamp!),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ]),
                      ),
                    ),
                  );
                });
          },
          error: (error, stackTrace) => Text('$error'),
          loading: () {
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}

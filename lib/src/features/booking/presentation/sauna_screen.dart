import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naytto/src/features/booking/data/booking_repository.dart';
import 'package:naytto/src/features/booking/domain/booking.dart';

class SaunaScreen extends ConsumerWidget {
  const SaunaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _bookingTimeController = TextEditingController();
    final _bookingDayController = TextEditingController();
    final _bookingEditTimeController = TextEditingController();
    final _bookingEditDayController = TextEditingController();
    final bookings = ref.watch(
      userBookingsProvider('sauna'),
    );
    String _selectedAmenityID = 'sauna1';

    return ColorfulSafeArea(
      color: Colors.white,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sauna booking',
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
                              padding: const EdgeInsets.all(6.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('id: ${booking.bookingID}'),
                                  Text('sauna: ${booking.amenityID}'),
                                  Text(
                                    booking.time ?? 'No time available',
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                  Text(
                                    booking.day ?? 'No day available',
                                    style: const TextStyle(color: Colors.black),
                                  ),

                                  // DELETE BOOKING
                                  TextButton(
                                    onPressed: () {
                                      ref
                                          .read(userBookingsProvider('sauna')
                                              .notifier)
                                          .deleteBooking(
                                              booking.bookingID, booking.type);
                                    },
                                    child: const Text('delete'),
                                  ),

                                  // EDIT BOOKING
                                  TextButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('edit booking'),
                                            content: Column(
                                              children: [
                                                TextField(
                                                  decoration:
                                                      const InputDecoration(
                                                          hintText: 'day'),
                                                  controller:
                                                      _bookingEditDayController,
                                                ),
                                                TextField(
                                                  decoration:
                                                      const InputDecoration(
                                                          hintText: 'time'),
                                                  controller:
                                                      _bookingEditTimeController,
                                                ),
                                                DropdownExample(
                                                  onValueChanged: (newValue) {
                                                    _selectedAmenityID =
                                                        newValue;
                                                  },
                                                )
                                              ],
                                            ),
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
                                                        .read(
                                                            userBookingsProvider(
                                                                    'sauna')
                                                                .notifier)
                                                        .updateBooking(
                                                            booking.bookingID,
                                                            Booking(
                                                                bookingID:
                                                                    booking
                                                                        .bookingID,
                                                                apartmentID:
                                                                    'A1',
                                                                amenityID:
                                                                    _selectedAmenityID,
                                                                time:
                                                                    _bookingEditTimeController
                                                                        .text,
                                                                day:
                                                                    _bookingEditDayController
                                                                        .text,
                                                                type: 'sauna'));
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Update'))
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: const Text('edit'),
                                  )
                                ],
                              ),
                            );
                          });
                    },
                    error: (error, stackTrace) => Text('$error'),
                    loading: () => const CircularProgressIndicator()),

                // ADD BOOKING
                TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('add booking'),
                            content: Column(
                              children: [
                                TextField(
                                  decoration:
                                      const InputDecoration(hintText: 'day'),
                                  controller: _bookingDayController,
                                ),
                                TextField(
                                  decoration:
                                      const InputDecoration(hintText: 'time'),
                                  controller: _bookingTimeController,
                                ),
                                DropdownExample(
                                  onValueChanged: (newValue) {
                                    _selectedAmenityID = newValue;
                                  },
                                )
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                  onPressed: () {
                                    if (_bookingDayController.text
                                        .trim()
                                        .isEmpty) {
                                      return;
                                    }

                                    if (_bookingTimeController.text
                                        .trim()
                                        .isEmpty) {
                                      return;
                                    }

                                    ref
                                        .read(userBookingsProvider('sauna')
                                            .notifier)
                                        .addBooking(Booking(
                                            bookingID: '',
                                            apartmentID: 'A1',
                                            amenityID: _selectedAmenityID,
                                            time: _bookingTimeController.text,
                                            day: _bookingDayController.text,
                                            type: 'sauna'));
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

class DropdownExample extends StatefulWidget {
  final void Function(String) onValueChanged; // Callback function

  const DropdownExample({Key? key, required this.onValueChanged})
      : super(key: key);

  @override
  _DropdownExampleState createState() => _DropdownExampleState();
}

class _DropdownExampleState extends State<DropdownExample> {
  String _selectedItem = 'sauna1'; // Initially selected item

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: _selectedItem,
      onChanged: (String? newValue) {
        setState(() {
          _selectedItem = newValue!;
          widget.onValueChanged(newValue);
        });
      },
      items: <String>[
        'sauna1',
        'sauna2',
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

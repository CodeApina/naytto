import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naytto/src/features/authentication/domain/app_user.dart';
import 'package:naytto/src/features/booking/data/amenities_repository.dart';
import 'package:naytto/src/features/booking/data/new_booking_repository.dart';
import 'package:naytto/src/features/booking/domain/amenity.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:naytto/src/features/booking/domain/booking.dart';
import 'package:intl/intl.dart';
import 'package:naytto/src/routing/app_router.dart';

// PROVIDERS

// Define a StateProvider to manage the selected Amenity
final selectedAmenityProvider = StateProvider<Amenity>((ref) {
  // Initialize with default values
  return Amenity(
      amenityID: '',
      displayName: '',
      availableFrom: '',
      availableTo: '',
      outOfService: false);
});

// Define a StateProvider to manage the selected DateTime
final selectedDateTimeProvider = StateProvider<DateTime>((ref) {
  // Initialize with the current date and time
  return DateTime.now();
});

// Define a StateProvider to manage the selected time slot
final selectedTimeSlotProvider = StateProvider<DateTime?>((ref) => null);

// Define a StateProvider to manage whether an amenity has been chosen
// prevents certain parts of the UI from being shown until an amenity has been chosen
final hasAmenityBeenChosenProvider = StateProvider<bool>((ref) => false);

class LaundryScreen extends ConsumerWidget {
  const LaundryScreen({super.key});

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
          'Book laundry',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      body: const ColorfulSafeArea(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              LaundryMachineSelection(),
              SizedBox(height: 20),
              DateSelection(),
              AvailableTimes(),
              SizedBox(height: 20),
              ConfirmBookingButton()
            ],
          ),
        ),
      ),
    );
  }
}

class LaundryMachineSelection extends ConsumerWidget {
  const LaundryMachineSelection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final amenities = ref.watch(AmenitiesListProvider('laundry'));
    return amenities.when(
      data: (amenities) {
        return Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            AmenityDropdownMenu(amenities: amenities)
          ],
        );
      },
      error: (error, stackTrace) => Text('$error'),
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class AmenityDropdownMenu extends ConsumerStatefulWidget {
  const AmenityDropdownMenu({super.key, required this.amenities});

  final List<Amenity> amenities;

  @override
  ConsumerState<AmenityDropdownMenu> createState() =>
      _AmenityDropdownMenuState();
}

class _AmenityDropdownMenuState extends ConsumerState<AmenityDropdownMenu> {
  late Amenity selectedAmenity;

  @override
  void initState() {
    super.initState();
    selectedAmenity = widget.amenities.first;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<Amenity>(
      label: const Text('Select machine'),
      leadingIcon: const Icon(Icons.local_laundry_service_rounded),
      width: MediaQuery.of(context).size.width * 0.8,
      onSelected: (Amenity? value) {
        setState(() {
          selectedAmenity = value!;
          ref.read(selectedAmenityProvider.notifier).state = value;
          ref.read(hasAmenityBeenChosenProvider.notifier).state = true;
        });
      },
      dropdownMenuEntries:
          widget.amenities.map<DropdownMenuEntry<Amenity>>((amenity) {
        return DropdownMenuEntry<Amenity>(
          label: amenity.displayName,
          value: amenity,
        );
      }).toList(),
    );
  }
}

class DateSelection extends ConsumerStatefulWidget {
  const DateSelection({super.key});

  @override
  ConsumerState<DateSelection> createState() => _DateSelectionState();
}

class _DateSelectionState extends ConsumerState<DateSelection> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: EasyInfiniteDateTimeLine(
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 30)),
        focusDate: selectedDate,
        onDateChange: (selectedDate) {
          setState(() {
            this.selectedDate = selectedDate;
            ref.read(selectedDateTimeProvider.notifier).state = selectedDate;
          });
        },
      ),
    );
  }
}

class AvailableTimes extends ConsumerWidget {
  const AvailableTimes({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateTimeProvider);
    final selectedAmenity = ref.watch(selectedAmenityProvider);
    final selectedAmenityID = selectedAmenity.amenityID;
    final AsyncValue<List<Booking>> bookings =
        ref.watch(BookingsStreamProvider(selectedAmenityID, selectedDate));

    final bool hasAmenityBeenChosen = ref.watch(hasAmenityBeenChosenProvider);

    if (!hasAmenityBeenChosen) {
      return Container();
    } else {
      final availableTimes = generateAvailableTimes(selectedDate,
          selectedAmenity.availableFrom, selectedAmenity.availableTo);
      return bookings.when(
        data: (bookings) {
          // Display available timeslots as choice chips
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Text('Available times',
                    style: Theme.of(context).textTheme.titleMedium),
                // Use Wrap to display choice chips horizontally and have a consistent
                // UI look despite the number of choicechips
                Wrap(
                  children: availableTimes.map((timeslot) {
                    return isTimeSlotAvailable(bookings, timeslot)
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TimeSlotChoiceChip(timeslot: timeslot),
                          )
                        : const SizedBox.shrink();
                  }).toList(),
                ),
              ],
            ),
          );
        },
        error: (error, stackTrace) => Text('$error'),
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
      );
    }
  }
}

List<DateTime> generateAvailableTimes(
    DateTime chosenDate, String availableFrom, String availableTo) {
  int fromHour = int.parse(availableFrom);
  int toHour = int.parse(availableTo);

  final earliestTime =
      DateTime(chosenDate.year, chosenDate.month, chosenDate.day, fromHour, 0);
  final latestTime =
      DateTime(chosenDate.year, chosenDate.month, chosenDate.day, toHour, 0);

  List<DateTime> availableTimes = [];

  // Add the earliestTime as the first item in the list
  availableTimes.add(earliestTime);

  // Iterate through the hours between fromHour and toHour, excluding the earliest and latest times
  for (int hour = fromHour + 1; hour < toHour; hour++) {
    DateTime time =
        DateTime(chosenDate.year, chosenDate.month, chosenDate.day, hour, 0);
    availableTimes.add(time);
  }

  // Add the latestTime as the last item in the list
  availableTimes.add(latestTime);

  return availableTimes;
}

bool isTimeSlotAvailable(List<Booking> bookings, DateTime time) {
  int hour = time.hour; // Extract the hour from the given time

  // Check if there are any bookings with the same hour as the given time
  return !bookings.any((booking) {
    int bookingHour = booking.timestamp!
        .toDate()
        .hour; // Extract the hour from the booking timestamp
    return bookingHour ==
        hour; // Return false if a booking exists for the same hour
  });
}

class TimeSlotChoiceChip extends ConsumerWidget {
  const TimeSlotChoiceChip({Key? key, required this.timeslot})
      : super(key: key);

  final DateTime timeslot;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTimeSlot = ref.watch(selectedTimeSlotProvider);

    return ChoiceChip(
      label: Text(DateFormat.Hm().format(timeslot)),
      selected: selectedTimeSlot == timeslot,
      onSelected: (_) {
        ref.read(selectedTimeSlotProvider.notifier).state = timeslot;
      },
    );
  }
}

class ConfirmBookingButton extends ConsumerWidget {
  const ConfirmBookingButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedAmenity = ref.watch(selectedAmenityProvider);
    final user = ref.watch(AppUser().provider);
    final housingCooperative = user.housingCooperative;
    final apartmentID = user.apartmentId;
    final amenityID = selectedAmenity.amenityID;
    final selectedTimeSlot = ref.watch(selectedTimeSlotProvider);
    final hasAmenityBeenChosen = ref.watch(hasAmenityBeenChosenProvider);

    if (!hasAmenityBeenChosen) {
      return Container();
    } else {
      return Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
        child: FilledButton(
            style: ButtonStyle(
                minimumSize: MaterialStatePropertyAll(
                    Size(MediaQuery.of(context).size.width, 50))),
            onPressed: () {
              ref.read(newBookingRepositoryProvider).addBooking(
                  housingCooperative: housingCooperative,
                  booking: Booking(
                      bookingID: '',
                      apartmentID: apartmentID,
                      amenityID: amenityID,
                      timestamp: Timestamp.fromDate(selectedTimeSlot!),
                      type: 'laundry'));
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 30),
                Icon(Icons.check),
                SizedBox(width: 60),
                Text('Confirm booking'),
              ],
            )),
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naytto/src/constants/theme.dart';
import 'package:naytto/src/features/authentication/domain/app_user.dart';
import 'package:naytto/src/features/booking/data/ollinbookingrepo.dart';
import 'package:naytto/src/features/booking/domain/ollinsaunabookings.dart';

class SaunaScreen extends ConsumerWidget {
  const SaunaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back,
              )),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'Book Sauna',
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ),
        // appBar: AppBar(
        //   title: const Text('Sauna Booking'),
        //   leading: IconButton(
        //     icon: const Icon(Icons.arrow_back),
        //     onPressed: () {
        //       Navigator.of(context).pop();
        //     },
        //   ),
        // ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 25,
              ),
              Center(
                child: Container(
                    constraints: const BoxConstraints(
                      maxWidth: 300,
                      minWidth: 100,
                      minHeight: 60,
                    ),
                    decoration: BoxDecoration(border: Border.all(width: 0.6)),
                    child: const SaunaSelector()),
              ),
              const SizedBox(
                height: 25,
              ),
              const _BookingContents(),
            ],
          ),
        )
        //   ],
        // ),
        );
  }
}

class SaunaSelector extends ConsumerWidget {
  const SaunaSelector({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // String? _selectedSaunaId;
    final AsyncValue<List<String>> saunaList = ref.watch(getSaunasProvider);
    final selectedSauna = ref.watch(selectedSaunaID);
    return Center(
      child: saunaList.when(
        loading: () => const CircularProgressIndicator(),
        error: (error, stackTrace) => Text("error: $error"),
        data: (saunaIds) {
          // if (_selectedSaunaId == null && saunaIds.isNotEmpty) {
          //   _selectedSaunaId = selectedSauna;
          // }
          return DropdownButton<String>(
            iconSize: 30,
            value: selectedSauna,
            onChanged: (String? newValue) {
              ref.read(selectedSaunaID.notifier).state = newValue!;

              // _selectedSaunaId = newValue;
            },
            items: saunaIds.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Row(
                  children: [
                    const Icon(Icons.shower),
                    const SizedBox(width: 10),
                    Text(
                      value,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const SizedBox(width: 70),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class _BookingContents extends ConsumerWidget {
  const _BookingContents();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(selectedSaunaID);
    final saunaDataAsyncValue = ref.watch(saunaDataStreamProvider);
    final saunaDataUpdate = ref.read(saunaDataUpdateProvider);
    final appUser = ref.watch(AppUser().provider);
    return saunaDataAsyncValue.when(
      data: (saunaDataList) {
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 10),
          itemCount: saunaDataList.length,
          itemBuilder: (context, index) {
            final booking = saunaDataList[index];

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 30,
                  // mainAxisExtent: 300),
                  childAspectRatio: 0.6),
              itemCount: booking.fields.length,
              itemBuilder: (context, idx) {
                final entry = booking.fields.entries.toList()[idx];
                final fieldName = entry.key;
                final fieldValue = entry.value;
                String weekDay = '';
                if (fieldName == '1') weekDay = "Monday";
                if (fieldName == '2') weekDay = "Tuesday";
                if (fieldName == '3') weekDay = "Wednesday";
                if (fieldName == '4') weekDay = "Thursday";
                if (fieldName == '5') weekDay = "Friday";
                if (fieldName == '6') weekDay = "Saturday";
                if (fieldName == '7') weekDay = "Sunday";

                return Column(
                  children: [
                    Text(
                      weekDay,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ...fieldValue.entries.map((fieldEntry) {
                      String time = fieldEntry.key;

                      bool available = fieldEntry.value['available'] as bool;

                      return Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          // padding: EdgeInsets.all(1),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7.0),
                              ),
                              side: const BorderSide(
                                color: Color.fromARGB(78, 16, 3, 3),
                                width: 2.0,
                              ),
                              minimumSize: const Size(200, 0),
                              backgroundColor: available
                                  ? Color.fromARGB(255, 117, 223, 147)
                                  : const Color.fromARGB(210, 255, 138, 66),
                            ),
                            onPressed: available
                                ? () async {
                                    final bool? confirm = await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Change Booking'),
                                          content: const Text(
                                            'Are you sure you want to change your saunas time?',
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(false);
                                              },
                                              child: const Text('No'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(true);
                                              },
                                              child: const Text('Yes'),
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    if (confirm ?? false) {
                                      try {
                                        await saunaDataUpdate.updateSaunaData(
                                            booking.id,
                                            fieldName,
                                            time,
                                            available!,
                                            weekDay);
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Error updating sauna data',
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  }
                                : () {},
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '$time:00-${int.parse(time) + 1}:00',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                if (appUser.apartmentId ==
                                    fieldEntry.value['apartmentID'])
                                  const Text('This is your time',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold))
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                );
              },
            );
          },
        );
      },
      loading: () => Center(
        child: const CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => Center(
        child: Text('Error: $error'),
      ),
    );
  }
}

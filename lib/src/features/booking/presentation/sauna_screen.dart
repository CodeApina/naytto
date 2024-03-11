import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:naytto/src/features/authentication/domain/app_user.dart';
import 'package:naytto/src/features/booking/data/ollinbookingrepo.dart';
import 'package:naytto/src/features/booking/domain/ollinsaunabookings.dart';

class SaunaScreen extends ConsumerWidget {
  const SaunaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saunaDataAsyncValue = ref.watch(saunaDataStreamProvider);
    final saunaDataUpdate = ref.read(saunaDataUpdateProvider);
    // final String apartmentid = ref.watch(AppUser().provider).apartmentId;
    return Scaffold(
      appBar: AppBar(
        title: Text('Sauna Booking'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: saunaDataAsyncValue.when(
        data: (saunaDataList) {
          return ListView.builder(
            itemCount: saunaDataList.length,
            itemBuilder: (context, index) {
              final booking = saunaDataList[index];
              return ListTile(
                title: Center(child: Text(booking.id)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(children: [
                        Text('Available from: ${booking.availableFrom}:00'),
                        Text('Available to: ${booking.availableTo}:00'),
                        // Text('Sauna id: ${booking.displayName}'),
                      ]),
                    ),

                    SizedBox(height: 8),
                    // Text('Weekday:'),
                    ...booking.fields.entries.map((entry) {
                      String fieldName = entry.key;
                      Map<String, bool> fieldValue = entry.value;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // fieldName == '1'
                          //     ? Text(
                          //         'Monday:',
                          //       )
                          //     : Text(
                          //         'Thuesday',
                          //       ),
                          if (fieldName == '1') Text('Monday'),
                          if (fieldName == '2') Text('Tuesday'),
                          if (fieldName == '3') Text('Wednesday'),
                          if (fieldName == '4') Text('Thursday'),
                          if (fieldName == '5') Text('Friday'),
                          if (fieldName == '6') Text('Saturday'),
                          if (fieldName == '7') Text('Sunday'),
                          ...fieldValue.entries.map((fieldEntry) {
                            String time = fieldEntry.key;
                            bool available = fieldEntry.value;
                            //not used in this version
                            final String path =
                                '${booking.displayName}/$fieldName/$time';
                            return Center(
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  minimumSize:
                                      MaterialStateProperty.all(Size(250, 36)),
                                  maximumSize:
                                      MaterialStateProperty.all(Size(300, 36)),
                                ),
                                onPressed: () async {
                                  // opens verification modal
                                  final bool? confirm = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Change Booking'),
                                        content: Text(
                                            'Are you sure you want to change your saunas time?'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(false);
                                            },
                                            child: Text('No'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(true);
                                            },
                                            child: Text('Yes'),
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
                                          available);
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Error updating sauna data',
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                },
                                child: Text(
                                  '$time:00-${int.parse(time) + 1}:00   ${available ? 'Available' : 'Not available'}',
                                  style: TextStyle(
                                    color:
                                        available ? Colors.green : Colors.red,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              );
            },
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Text('Error: $error'),
        ),
        // Add handling for the situation when data is empty
        // .empty: () => Center(
        //   child: Text('No sauna data available.'),
        // ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naytto/src/constants/firestore_constants.dart';
import 'package:naytto/src/constants/theme.dart';
import 'package:naytto/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:naytto/src/features/authentication/domain/app_user.dart';
import 'package:naytto/src/features/booking/domain/booking.dart';
import 'package:naytto/src/utilities/housing_cooperative_creator.dart';

class DevScreen extends ConsumerWidget {
  DevScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textController1 = TextEditingController();
    final textController2 = TextEditingController();
    final textController3 = TextEditingController();

    return ColorfulSafeArea(
      color: Colors.white,
      child: Scaffold(
        body: Container(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextButton(
                      onPressed: () async {
                        await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                    content: Stack(
                                  clipBehavior: Clip.none,
                                  children: <Widget>[
                                    Positioned(
                                      right: -40,
                                      top: -40,
                                      child: InkResponse(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const CircleAvatar(
                                          backgroundColor: Colors.red,
                                          child: Icon(Icons.close),
                                        ),
                                      ),
                                    ),
                                    Form(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          const Text(
                                              "Housing cooperative name:"),
                                          Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: TextFormField(
                                                controller: textController1),
                                          ),
                                          const Text(
                                              "Housing cooperative address:"),
                                          Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: TextFormField(
                                                controller: textController2),
                                          ),
                                          const Text(
                                              "Number of apartments wanted:"),
                                          Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: TextFormField(
                                              controller: textController3,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: ElevatedButton(
                                              child: const Text("Submit"),
                                              onPressed: () {
                                                HousingCooperativeCreator()
                                                    .CreateNewHousingCooperative(
                                                        textController1.text,
                                                        textController2.text,
                                                        int.parse(
                                                            textController3
                                                                .text));
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                )));
                      },
                      child: const Text('Create Housing Cooperative')),
                  TextButton(
                      onPressed: () {
                        changeAvailability();
                      },
                      child: const Text('Change sauna availability')),
                  TextButton(
                      onPressed: () {
                        // Put logic here
                      },
                      child: const Text('Button 3')),
                  TextButton(
                      onPressed: () {
                        // Put logic here
                      },
                      child: const Text('Button 4')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final firestore = FirebaseFirestore.instance;

void changeAvailability() async {
  try {
    const String saunaID = 'wzGX3LgczNKcKGoLxima';
    const String day = 'monday';
    const String time = '17';
    const String housingCooperative = "Pilvilinna";
    const String apartmentNumber = "A1";
    const String bookingType = "sauna";

    final docref = firestore
      .collection(FirestoreCollections.housingCooperative)
      .doc(housingCooperative);

    final documentReference = docref
        .collection(FirestoreCollections.saunas)
        .doc(saunaID);

    final snapshot = await documentReference.get();

    final weekdays = snapshot.data()?[FirestoreFields.saunaWeekdays] ?? {};

    // Check if time is available
    // if available set to unavailable
    if (weekdays[day][time] == true) {
      weekdays[day][time] = false;

      await docref
          .collection(FirestoreCollections.bookings)
          .doc()
          .set({
        FirestoreFields.bookingApartmentID: apartmentNumber,
        FirestoreFields.bookingDay: day,
        FirestoreFields.bookingTime: time,
        FirestoreFields.bookingID: saunaID,
        FirestoreFields.bookingType: bookingType,
      });
    } else if ((weekdays[day][time] == false)) {
      weekdays[day][time] = true;
      final querySnapshot = await docref
          .collection(FirestoreCollections.bookings)
          .where(FirestoreFields.bookingDay, isEqualTo: day)
          .where(FirestoreFields.bookingTime, isEqualTo: time)
          .where(FirestoreFields.bookingID, isEqualTo: saunaID)
          .where(FirestoreFields.bookingApartmentID, isEqualTo: apartmentNumber)
          .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
    }

    await documentReference.update({FirestoreFields.saunaWeekdays: weekdays});
  } catch (e) {
    print('Error changing availability: $e');
  }
}

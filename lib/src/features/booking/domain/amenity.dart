import 'package:naytto/src/constants/firestore_constants.dart';

class Amenity {
  Amenity({
    required this.amenityID,
    required this.displayName,
    required this.availableFrom,
    required this.availableTo,
    required this.outOfService,
    // required this.weekDays,
  });
  final String amenityID;
  final String displayName;
  final String availableFrom;
  final String availableTo;
  final bool outOfService;
  // final List<WeekDay> weekDays;

  factory Amenity.fromMap(Map<String, dynamic> snapshot, String id) {
    // final weekdaylistdynamic = snapshot['timeslots'] as List<dynamic>;
    // final weekDayList =
    //     weekdaylistdynamic.map((e) => WeekDay.fromMap(e)).toList();
    return Amenity(
      amenityID: id,
      displayName: snapshot[FirestoreFields.amenityDisplayName] as String,
      availableFrom: snapshot[FirestoreFields.amenityAvailableFrom] as String,
      availableTo: snapshot[FirestoreFields.amenityAvailableTo] as String,
      outOfService: snapshot[FirestoreFields.amenityOutOfService] as bool,
      // weekDays: weekDayList,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      FirestoreFields.amenityID: amenityID,
      FirestoreFields.amenityDisplayName: displayName,
      FirestoreFields.amenityAvailableFrom: availableFrom,
      FirestoreFields.amenityAvailableTo: availableTo,
      FirestoreFields.amenityOutOfService: outOfService,
    };
  }
}

// class WeekDay {
//   WeekDay({
//     required this.day,
//     required this.timeSlots,
//   });
//   final String day;
//   final List<TimeSlot> timeSlots;

//   factory WeekDay.fromMap(Map<String, dynamic> snapshot) {
//     final timeslotlistdynamic = snapshot['hours'] as List<dynamic>;
//     final timeslotlist =
//         timeslotlistdynamic.map((e) => TimeSlot.fromMap(e)).toList();
//     return WeekDay(
//       day: snapshot['day_name'] as String,
//       timeSlots: timeslotlist,
//     );
//   }
// }

// class TimeSlot {
//   TimeSlot({
//     required this.time,
//     required this.availability,
//   });
//   final String time;
//   final bool availability;

//   factory TimeSlot.fromMap(Map<String, dynamic> snapshot) {
//     return TimeSlot(
//       time: snapshot['timeslot'] as String,
//       availability: snapshot['availability'] as bool,
//     );
//   }
// }

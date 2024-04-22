import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:naytto/src/constants/firestore_constants.dart';
import 'package:naytto/src/features/authentication/domain/app_user.dart';
import 'package:naytto/src/features/maintenance/data/firebase_maintenance.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class Maintenance{
  late final String maintenanceId;
  final String date;
  final String apartmentNumber;
  final String reason;
  final String body;
  final String type;
  final int status;


  Maintenance({required this.maintenanceId, required this.date, required this.apartmentNumber, required this.reason, required this.body, required this.type, required this.status});

  factory Maintenance.fromFirestore(Map<String, dynamic> snapshot, id) {
    return Maintenance(
      maintenanceId : id,
      date: DateFormat("dd/MM/yyyy, HH:mm").format(DateTime.fromMicrosecondsSinceEpoch(snapshot[FirestoreFields.maintenanceDate])),
      apartmentNumber: snapshot[FirestoreFields.maintenanceApartmentNumber],
      reason: snapshot[FirestoreFields.maintenanceReason],
      body: snapshot[FirestoreFields.maintenanceBody],
      type: snapshot[FirestoreFields.maintenanceType],
      status: snapshot[FirestoreFields.maintenanceStatus]
      );
  }
  // Translates maintenance object into a map to be stored in Firestore
  Map<String,dynamic> toFirestore(){
    return <String,dynamic>{
      FirestoreFields.maintenanceDate: int.parse(date),
      FirestoreFields.maintenanceReason: reason,
      FirestoreFields.maintenanceBody: body,
      FirestoreFields.maintenanceType: type,
      FirestoreFields.maintenanceStatus: status,
      FirestoreFields.maintenanceApartmentNumber: apartmentNumber
    };
  }
  
  // Translates status text into a text format to be used in text fields
  String statusTextGiver(){
    String statusText;
    switch(status){
      case 0:
        statusText = "Sent";
        break;
      case 1:
        statusText = "Received";
        break;
      case 2:
        statusText = "Active";
        break;
      case 3:
        statusText = "Complete";
        break;
      default:
        statusText = "Not sent";
        break;
    }
    return statusText;
  }

  
}
// Creates a new ticket for maintenance
bool createTicket(text1, text2, text3){
    storeTicketToFirestore(Maintenance(maintenanceId: "new", date: DateTime.now().microsecondsSinceEpoch.toString(), apartmentNumber: AppUser().apartmentId, reason: text1, body: text2, type: text3, status: 0 ).toFirestore());
    return false;
  }

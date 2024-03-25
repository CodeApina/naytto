import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String formatTimestamp(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
  String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
  return formattedDate;
}

String formatTimestampWithHHmm(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
  String formatTimestampWithHHmm =
      DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  return formatTimestampWithHHmm;
}

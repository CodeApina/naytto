import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreenDatabaseMethods {
  final StreamController<List<Map<String, dynamic>>> _controller =
      StreamController<List<Map<String, dynamic>>>();

  Stream<List<Map<String, dynamic>>> getAnnouncementText() {
    _getAnnouncementText();
    return _controller.stream;
  }

  Future<void> _getAnnouncementText() async {
    {
      FirebaseFirestore.instance
          .collection('apartments')
          .snapshots()
          .listen((apartmentsSnapshot) async {
        List<Map<String, dynamic>> dataList = [];

        for (final apartmentDoc in apartmentsSnapshot.docs) {
          final announcementSnapshot =
              await apartmentDoc.reference.collection('announcement').get();
          final docList = announcementSnapshot.docs.map((doc) {
            return {
              'text': doc.get('text') as String,
              'date': doc.get('date') as Timestamp,
            };
          }).toList();
          dataList.addAll(docList);
        }

        _controller.add(dataList);
      });
    }
  }

  //Not working
  void announcementListener() {
    FirebaseFirestore.instance
        .collection('apartments')
        .snapshots()
        .listen((apartmentsSnapshot) {
      apartmentsSnapshot.docChanges.forEach((change) {
        if (change.type == DocumentChangeType.added ||
            change.type == DocumentChangeType.modified ||
            change.type == DocumentChangeType.removed) {
          _getAnnouncementText();
        }
      });
    });
  }
}

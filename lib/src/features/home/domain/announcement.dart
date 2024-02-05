import 'package:flutter/material.dart';
import 'package:naytto/src/common_widgets/common_container.dart';
import 'package:naytto/src/features/home/data/announcements_repository.dart';
import 'package:intl/intl.dart';

// This file is not in active use

class AnnouncementWidget extends StatelessWidget {
  final HomeScreenDatabaseMethods databaseMethods = HomeScreenDatabaseMethods();

  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: databaseMethods.getAnnouncementText(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        final dataList = snapshot.data ?? [];

        List<Widget> columns = [];
        for (final data in dataList) {
          columns.add(
            CommonContainer(
              height: 100,
              width: 325,
              child: Column(
                children: [
                  Text(
                    DateFormat('dd/MM/yyyy').format(data['date'].toDate()),
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  Text(data['text']),
                ],
              ),
            ),
          );
          columns.add(
            SizedBox(
              height: 20,
            ),
          );
        }
        return Column(
          children: columns,
        );
      },
    );
  }
}

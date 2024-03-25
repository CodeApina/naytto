import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naytto/src/features/home/domain/announcement.dart';
import 'package:naytto/src/routing/app_router.dart';

class AnnouncementViewScreen extends ConsumerWidget {
  const AnnouncementViewScreen({super.key, required this.announcement});

  final Announcement announcement;

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
          'Announcement Details',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      body: ColorfulSafeArea(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                announcement.title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                announcement.body,
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

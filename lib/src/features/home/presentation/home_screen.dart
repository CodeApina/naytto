import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naytto/src/common_widgets/icon_container.dart';
import 'package:naytto/src/constants/theme.dart';
import 'package:naytto/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:naytto/src/features/authentication/domain/user.dart';
import 'package:naytto/src/features/home/data/announcement_repository_new.dart';
import 'package:naytto/src/features/home/domain/announcement.dart';
import 'package:naytto/src/features/home/domain/announcement_new.dart';
import 'package:naytto/src/utilities/timestamp_formatter.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextButton(onPressed: () {}, child: Text('logout')),
                // SizedBox(
                //   height: 40,
                // ),
                _UserGreetings(),
                // _AnnouncementContents(),
                _AnnouncementsPreview(),
                SizedBox(
                  height: 10,
                ),
                _BookingContents(),
                SizedBox(
                  height: 20,
                ),
                _DashboardNavigationContents(),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// User greetings section
class _UserGreetings extends ConsumerWidget {
  const _UserGreetings();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authRepositoryProvider).currentUser;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
          child: Text(
            'Welcome home, ${currentUser!.email}',
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ),
      ],
    );
  }
}

// Bookings section
class _BookingContents extends StatelessWidget {
  const _BookingContents();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Upcoming bookings',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
          child: Container(
            decoration: BoxDecoration(
                color: colors(context).color3,
                borderRadius: BorderRadius.circular(10)),
            child: const ListTile(
                title: Text('05/02/2024 18:00-19:30'),
                leading: Icon(Icons.calendar_month),
                subtitle: Text(
                  'Laundry - machine 3',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                )),
          ),
        ),
      ],
    );
  }
}

// Dashboard navigation section
class _DashboardNavigationContents extends StatelessWidget {
  const _DashboardNavigationContents();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconContainer(
              iconText: 'Community',
              icon: IconButton(
                onPressed: () {
                  // add navigation logic in these onpressed functions
                },
                icon: const Icon(Icons.person),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            IconContainer(
              iconText: 'Billing',
              icon: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.payment),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconContainer(
              iconText: 'Placeholder',
              icon: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.place),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            IconContainer(
              iconText: 'Placeholder',
              icon: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.place),
              ),
            ),
          ],
        )
      ],
    );
  }
}

class _AnnouncementsPreview extends ConsumerWidget {
  const _AnnouncementsPreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // A widget rebuild happens each time the announcements collection
    // in Firestore is edited/added/removed
    final announcementsQuery =
        ref.watch(announcementsRepositoryProvider).announcementsQuery();
    return Column(
      children: [
        Text(
          'Announcements',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        FirestoreListView<Announcement>(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          query: announcementsQuery,
          pageSize: 2,
          itemBuilder: (context, snapshot) {
            final announcement = snapshot.data();
            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
              child: Container(
                decoration: BoxDecoration(
                  color: colors(context).color3,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(
                    formatTimestamp(announcement.timestamp),
                  ),
                  leading: announcement.urgency == 2
                      ? Icon(Icons.announcement)
                      : Icon(Icons.announcement_outlined),
                  subtitle: Text(
                    announcement.body,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

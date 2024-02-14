import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naytto/src/common_widgets/icon_container.dart';
import 'package:naytto/src/constants/theme.dart';
import 'package:naytto/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:naytto/src/features/authentication/domain/app_user.dart';
import 'package:naytto/src/features/home/data/announcement_repository.dart';
import 'package:naytto/src/utilities/timestamp_formatter.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ColorfulSafeArea(
      color: colors(context).color2!,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                colors(context).color2!,
                colors(context).color3!,
              ])),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextButton(
                      onPressed: () {
                        ref.read(authRepositoryProvider).signOut();
                      },
                      child: const Text('logout')),
                  const SizedBox(
                    height: 40,
                  ),
                  const _UserGreetings(),
                  const _AnnouncementsPreview(),
                  const SizedBox(
                    height: 10,
                  ),
                  const _BookingContents(),
                  const SizedBox(
                    height: 20,
                  ),
                  const _DashboardNavigationContents(),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
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
    final appUserWatcher = ref.watch(AppUser().provider);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
          child: Text(
            'Welcome home, ${appUserWatcher.email}',
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
  const _AnnouncementsPreview();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcements = ref.watch(announcementsProvider);
    return Column(
      children: [
        Text(
          'Announcements',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        announcements.when(
          data: (announcements) {
            return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: announcements.length,
                itemBuilder: (context, index) {
                  final announcement = announcements[index];
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
                            ? const Icon(Icons.announcement)
                            : const Icon(Icons.announcement_outlined),
                        subtitle: Text(
                          announcement.body,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ),
                  );
                });
          },
          error: (error, stackTrace) => Text('$error'),
          loading: () {
            return const CircularProgressIndicator();
          },
        )
      ],
    );
  }
}

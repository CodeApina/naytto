import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naytto/main.dart';
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
      color: Colors.white,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                colors(context).color1!,
                colors(context).color1!,
              ])),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                child: Text(
                  'Welcome home, ${appUserWatcher.email}',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
            ),
          ],
        ),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 0, 0),
              child: Text(
                'Announcements',
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 24, 0),
                child: InkWell(
                  onTap: () {},
                  child: Text(
                    'see more',
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall!
                        .copyWith(color: Colors.purple[600]),
                  ),
                )),
          ],
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
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              colors(context).color3!,
                              colors(context).color3!,
                            ]),
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
                          announcement.title,
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
            return const Center(child: CircularProgressIndicator());
          },
        )
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 0, 0),
                child: Text(
                  'Bookings',
                  style: Theme.of(context).textTheme.displayMedium,
                )),
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 24, 0),
                child: InkWell(
                  onTap: () {},
                  child: Text(
                    'see more',
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall!
                        .copyWith(color: Colors.purple[600]),
                  ),
                )),
          ],
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
class _DashboardNavigationContents extends ConsumerWidget {
  const _DashboardNavigationContents();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconContainer(
              iconText: 'Log out',
              icon: IconButton(
                onPressed: () {
                  ref.read(authRepositoryProvider).signOut();
                  ref.read(AppUser().provider).reset();
                },
                icon: const Icon(Icons.logout),
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

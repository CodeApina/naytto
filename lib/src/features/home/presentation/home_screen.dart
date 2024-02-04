import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naytto/src/common_widgets/common_container.dart';
import 'package:naytto/src/common_widgets/icon_container.dart';
import 'package:naytto/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:naytto/src/features/home/domain/announcement.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40,
                ),
                _UserGreetings(),
                _AnnouncementContents(),
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
    final currentUser = ref.watch(authRepositoryProvider).currentUser!.email;
    //not in use
    // final uid = ref.watch(authRepositoryProvider).currentUser!.uid;
    return Column(
      children: [
        Text(
          'Greetings, $currentUser',
          style: Theme.of(context).textTheme.displaySmall,
        )
      ],
    );
  }
}

// Announcements section
class _AnnouncementContents extends ConsumerWidget {
  const _AnnouncementContents();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(children: [
      Text(
        'Announcements:',
        style: Theme.of(context).textTheme.displayMedium,
      ),
      CommonContainer(
        height: 100,
        width: 325,
        child: Column(
          children: [
            Text(
              '02/02/2024',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            Text(
              'This is an announcement, This is an announcement, This is an announcement',
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      AnnouncementWidget(),
      const SizedBox(
        height: 20,
      ),
      CommonContainer(
        height: 100,
        width: 325,
        child: Column(
          children: [
            Text(
              '03/02/2024',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            Text(
              'This is also an announcement, This is also an announcement, This is also an announcement, ',
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ],
        ),
      )
    ]);
  }
}

// Bookings section
class _BookingContents extends StatelessWidget {
  const _BookingContents();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Text(
          'Upcoming bookings:',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        CommonContainer(
          height: 60,
          width: 325,
          child: Column(
            children: [
              Text(
                '02/02/2024             18:30-19:30',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              Text(
                'Laundry - Machine 3',
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ],
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

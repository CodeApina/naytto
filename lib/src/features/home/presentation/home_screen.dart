import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naytto/src/common_widgets/icon_container.dart';
import 'package:naytto/src/constants/theme.dart';
import 'package:naytto/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:naytto/src/features/authentication/domain/app_user.dart';
import 'package:naytto/src/features/home/data/announcement_repository.dart';
import 'package:naytto/src/features/home/data/bookings_homescreen_repository.dart';
import 'package:naytto/src/features/home/domain/bookings_homescreen.dart';
import 'package:naytto/src/utilities/timestamp_formatter.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appUserWatcher = ref.watch(AppUser().provider);
    return ColorfulSafeArea(
      color: const Color.fromRGBO(201, 202, 223, 1.0),
      child: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/talo2.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  Text(
                    'Welcome home, ${appUserWatcher.firstName}    ',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const Icon(
                    Icons.hail_rounded,
                    size: 40,
                    color: Color.fromRGBO(0, 124, 124, 1.0),
                  ),
                ],
              ),
              backgroundColor: const Color.fromARGB(220, 255, 255, 255),
            ),
            //makes scaffold transparent
            backgroundColor: Colors.transparent,
            body: const SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  // _UserGreetings(),
                  _AnnouncementsPreview(),
                  SizedBox(height: 10),
                  _BookingContents(),
                  SizedBox(height: 20),
                  _DashboardNavigationContents(),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// User greetings section
// class _UserGreetings extends ConsumerWidget {
//   const _UserGreetings();

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final appUserWatcher = ref.watch(AppUser().provider);
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
//                 child: Text(
//                   'Welcome home, ${appUserWatcher.firstName}',
//                   style: Theme.of(context).textTheme.displayLarge,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

class _AnnouncementsPreview extends ConsumerWidget {
  const _AnnouncementsPreview();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcements = ref.watch(announcementsProvider);
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      decoration: BoxDecoration(
        color: colors(context).color3,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 10, 0, 0),
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
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          color: const Color.fromRGBO(0, 124, 124, 1.0)),
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
                          color: Colors.grey.shade200,
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
      ),
    );
  }
}

// Bookings section
class _BookingContents extends ConsumerWidget {
  const _BookingContents();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookings = ref.watch(apartmentsBookingsProvider);
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      decoration: BoxDecoration(
        color: colors(context).color3,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
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
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          color: const Color.fromRGBO(0, 124, 124, 1.0)),
                    ),
                  )),
            ],
          ),
          bookings.when(
              data: (bookings) {
                return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: bookings.length,
                    itemBuilder: (context, index) {
                      final booking = bookings[index];
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: ListTile(
                              title: Text(
                                booking.type,
                              ),
                              subtitle: Text(
                                booking.day != null
                                    ? '${booking.day}, ${booking.time}'
                                    : formatTimestamp(booking.timestamp!),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ),
                        ),
                      );
                    });
              },
              error: (error, stackTrace) => Text('$error'),
              loading: () {
                return const Center(child: CircularProgressIndicator());
              }),
        ],
      ),
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
      ],
    );
  }
}

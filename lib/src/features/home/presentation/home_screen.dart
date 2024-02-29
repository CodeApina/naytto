import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naytto/main.dart';
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
      color: Colors.white,
      child: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('assets/talo2.jpg'),
                fit: BoxFit.cover,
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colors(context).color1!,
                  colors(context).color1!,
                ],
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
                  ),
                ],
              ),
              backgroundColor: Color.fromARGB(138, 240, 239, 239),
            ),
            //makes scaffold transparent
            backgroundColor: Colors.transparent,
            body: const SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 40),
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
      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 255, 229, 229),
              Color.fromARGB(0, 255, 255, 255),
              // colors(context).color3!,
              // colors(context).color2!,
            ]),
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
      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 252, 252, 252),
            Color.fromARGB(0, 255, 255, 255),
            // colors(context).color3!,
            // colors(context).color2!,
          ],
        ),
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
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall!
                          .copyWith(color: Colors.purple[600]),
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
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  colors(context).color3!,
                                  colors(context).color3!,
                                ]),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: ListTile(
                              title: Text(
                                booking.type,
                              ),
                              subtitle:
                                  // Text(
                                  // '${booking.day}, ${booking.time},
                                  Text(
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
          // Padding(
          //   padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
          //   // child: Container(
          //   //   decoration: BoxDecoration(
          //   //       color: colors(context).color3,
          //   //       borderRadius: BorderRadius.circular(10)),
          //   //   child: const ListTile(
          //   //       title: Text('05/02/2024 18:00-19:30'),
          //   //       leading: Icon(Icons.calendar_month),
          //   //       subtitle: Text(
          //   //         'Laundry - machine 3',
          //   //         overflow: TextOverflow.ellipsis,
          //   //         maxLines: 2,
          //   //       )),
          //   // ),
          // ),
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

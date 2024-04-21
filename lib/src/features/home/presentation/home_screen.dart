import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naytto/src/common_widgets/icon_container.dart';
import 'package:naytto/src/constants/theme.dart';
import 'package:naytto/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:naytto/src/features/authentication/domain/app_user.dart';
import 'package:naytto/src/features/home/data/announcement_repository.dart';
import 'package:naytto/src/features/home/data/bookings_homescreen_repository.dart';
import 'package:naytto/src/routing/app_router.dart';
import 'package:naytto/src/utilities/capitalizer.dart';
import 'package:naytto/src/utilities/timestamp_formatter.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appUserWatcher = ref.watch(AppUser().provider);
    return Stack(
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
            centerTitle: true,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome home, ${appUserWatcher.firstName}!    ',
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
          body: const ColorfulSafeArea(
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  // _UserGreetings(),
                  _AnnouncementsPreview(),
                  SizedBox(height: 10),
                  _BookingContents(),
                  SizedBox(height: 20),
                  // _DashboardNavigationContents(),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ],
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
    final announcements = ref.watch(announcementsHomeScreenProvider);
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      decoration: BoxDecoration(
        color: colors(context).color3,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 20, 0, 0),
                child: Text(
                  'Announcements',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                  child: InkWell(
                    onTap: () {
                      ref
                          .read(goRouterProvider)
                          .goNamed(AppRoute.announcements.name);
                    },
                    child: Text(
                      'show all',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
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
                      padding: const EdgeInsets.fromLTRB(18, 8, 24, 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          onTap: () {
                            ref.read(goRouterProvider).goNamed(
                                AppRoute.announcementview.name,
                                extra: announcement);
                          },
                          title: Row(
                            children: [
                              Text(
                                formatTimestamp(announcement.timestamp),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              const SizedBox(
                                  width:
                                      10), // Lisää tarvittaessa väliä title- ja subtitle-tekstien välille
                              Expanded(
                                child: Text(
                                  announcement.title,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Text(
                            announcement.body,
                            style: Theme.of(context).textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),

                          leading: announcement.urgency == 2
                              ? const Icon(
                                  Icons.announcement,
                                  color: Color.fromARGB(255, 241, 39, 25),
                                )
                              : const Icon(
                                  Icons.announcement_outlined,
                                  color: Color.fromARGB(255, 241, 39, 25),
                                ),
                          // subtitle: Text(
                          //   announcement.title,
                          //   overflow: TextOverflow.ellipsis,
                          //   maxLines: 3,
                          // ),
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

String buttonText = 'see more';

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
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                  padding: const EdgeInsets.fromLTRB(40, 20, 0, 0),
                  child: Text(
                    'Bookings',
                    style: Theme.of(context).textTheme.displayMedium,
                  )),
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 24, 0),
                  child: InkWell(
                    onTap: () {
                      // Updates how many bookings is shown and text
                      ref.read(AppUser().provider).bookingsShown =
                          buttonText == 'see more' ? 5 : 2;
                      buttonText =
                          buttonText == 'see more' ? 'see less' : 'see more';
                      ref.refresh(apartmentsBookingsProvider);
                    },
                    child: Text(
                      buttonText,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
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
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 10),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(128, 238, 238, 238),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                Row(children: [
                                  (booking.type == 'sauna')
                                      ? Icon(Icons.shower)
                                      : Icon(Icons.local_laundry_service_sharp),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    capitalizer(booking.type),
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall,
                                  ),
                                  SizedBox(
                                    width: 40,
                                  ),
                                  Text(
                                    booking.day != null
                                        ? '   ${booking.day}, ${booking.time}:00'
                                        : formatTimestampWithHHmm(
                                            booking.timestamp!),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ]),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(4, 3, 0, 0),
                                  child: Row(
                                    children: [
                                      (booking.type == 'sauna')
                                          ? Text(
                                              'Sauna: ',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            )
                                          : Text(
                                              'Laundy machine: ',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            ),
                                      Text(
                                        booking.displayname!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ],
                                  ),
                                )
                              ],
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
// not in use
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

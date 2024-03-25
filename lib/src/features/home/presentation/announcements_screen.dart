import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naytto/src/constants/theme.dart';
import 'package:naytto/src/features/home/data/announcement_repository.dart';
import 'package:naytto/src/features/home/domain/announcement.dart';
import 'package:naytto/src/features/home/presentation/announcement_view_screen.dart';
import 'package:naytto/src/routing/app_router.dart';
import 'package:naytto/src/utilities/timestamp_formatter.dart';
import 'package:animations/animations.dart';

class AnnouncementsScreen extends ConsumerWidget {
  const AnnouncementsScreen({super.key});

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
          'Announcements',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      body: const ColorfulSafeArea(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [_AnnouncementContents()],
          ),
        ),
      ),
    );
  }
}

class _AnnouncementContents extends ConsumerWidget {
  const _AnnouncementContents();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcements = ref.watch(allAnnouncementsProvider);
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      decoration: BoxDecoration(
        color: colors(context).color3,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          announcements.when(
            data: (announcements) {
              return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: announcements.length,
                  itemBuilder: (context, index) {
                    final announcement = announcements[index];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(18, 8, 0, 8),
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

class _OpenContainerWrapper extends StatelessWidget {
  const _OpenContainerWrapper({
    required this.id,
    required this.announcement,
    required this.closedChild,
  });

  final int id;
  final Announcement announcement;
  final Widget closedChild;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return OpenContainer(
      openBuilder: (context, closedContainer) {
        return AnnouncementViewScreen(announcement: announcement);
      },
      openColor: theme.cardColor,
      closedShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      closedElevation: 0,
      closedColor: theme.cardColor,
      closedBuilder: (context, openContainer) {
        return InkWell(
          onTap: () {
            openContainer();
          },
          child: closedChild,
        );
      },
    );
  }
}

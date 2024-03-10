import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naytto/src/common_widgets/icon_container.dart';
import 'package:naytto/src/routing/app_router.dart';

class BookingScreen extends ConsumerWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ColorfulSafeArea(
      color: Colors.white,
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to booking',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconContainer(
                  iconText: 'Book laundry',
                  icon: IconButton(
                    onPressed: () {
                      ref.read(goRouterProvider).goNamed(AppRoute.laundry.name);
                    },
                    icon: const Icon(Icons.calendar_month),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                IconContainer(
                  iconText: 'Book sauna',
                  icon: IconButton(
                    onPressed: () {
                      ref.read(goRouterProvider).goNamed(AppRoute.sauna.name);
                    },
                    icon: const Icon(Icons.calendar_month),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconContainer(
                  iconText: 'My bookings',
                  icon: IconButton(
                    onPressed: () {
                      ref
                          .read(goRouterProvider)
                          .goNamed(AppRoute.mybookings.name);
                    },
                    icon: const Icon(Icons.calendar_month),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

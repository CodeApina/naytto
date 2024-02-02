import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naytto/src/routing/app_router.dart';

class BookingScreen extends ConsumerWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Text('Welcome to booking'),
            TextButton(
                onPressed: () {
                  ref.read(goRouterProvider).goNamed(AppRoute.sauna.name);
                },
                child: const Text('Saunas')),
            TextButton(
                onPressed: () {
                  ref.read(goRouterProvider).goNamed(AppRoute.laundry.name);
                },
                child: const Text('Laundry')),
          ],
        ),
      ),
    );
  }
}

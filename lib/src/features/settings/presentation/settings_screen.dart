import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naytto/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:naytto/src/features/authentication/domain/app_user.dart';
// import 'package:naytto/src/routing/app_router.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Settings Screen',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              SizedBox(
                height: 40,
              ),
              Text('Log out'),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  ref.read(authRepositoryProvider).signOut();
                  ref.read(AppUser().provider).reset();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

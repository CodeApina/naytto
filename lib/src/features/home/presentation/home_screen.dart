import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naytto/src/features/authentication/data/firebase_auth_repository.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authRepositoryProvider).currentUser!.email;
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.login),
            label: const Text('Logout'),
            onPressed: () {
              ref.read(authRepositoryProvider).signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Text('Welcome home ${currentUser}'),
          ],
        ),
      ),
    );
  }
}

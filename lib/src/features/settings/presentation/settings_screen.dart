import 'package:flutter/gestures.dart';
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
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            'My profile',
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(64, 0, 64, 0),
                child: ElevatedButton(
                    onPressed: () {
                      ref.read(authRepositoryProvider).signOut();
                      ref.read(AppUser().provider).reset();
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.logout,
                          color: Color.fromRGBO(0, 124, 124, 1.0),
                        ),
                        SizedBox(width: 12),
                        Text('Sign out')
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}

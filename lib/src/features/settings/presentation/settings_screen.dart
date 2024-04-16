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
    final appUser = ref.watch(AppUser().provider);
    return SafeArea(
      child: Scaffold(
          // appBar: AppBar(
          //   centerTitle: true,
          //   backgroundColor: Colors.white,
          //   title: Text(
          //     'My profile',
          //     style: Theme.of(context).textTheme.displayLarge,
          //   ),
          // ),
          body: Center(
        child: Container(
          // decoration: BoxDecoration(
          //   color: const Color.fromARGB(128, 238, 238, 238),
          //   borderRadius: BorderRadius.circular(20),
          // ),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'My profile',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Name:',
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Adress:',
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Tel:',
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Email:',
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'My housingC:',
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              appUser.firstName,
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              appUser.lastName,
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              appUser.housingCooperativeAddress,
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              appUser.apartmentId,
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              appUser.tel,
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              appUser.email,
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              appUser.housingCooperative,
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 60,
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
      )),
    );
  }
}

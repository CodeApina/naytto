import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naytto/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:naytto/src/features/authentication/domain/app_user.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    MediaQueryData queryData = MediaQuery.of(context);
    final appUser = ref.watch(AppUser().provider);
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
        body: Opacity(
          opacity: 1,
          child: Container(
            height: queryData.size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Color.fromARGB(180, 146, 227, 169), BlendMode.overlay),
                image: AssetImage('assets/postilaatikko.jpg'),
                fit: BoxFit.cover,
                // alignment: FractionalOffset(0.5, -5),
              ),
            ),
            child: Center(
              child: Stack(
                children: [
                  Positioned(
                    top: queryData.size.height * 0.22,
                    left: queryData.size.width * 0.15,
                    right: queryData.size.width * 0.15,
                    child: Container(
                      decoration:
                          BoxDecoration(color: Color.fromARGB(169, 0, 0, 0)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            appUser.firstName,
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                    color: Color.fromARGB(221, 255, 255, 255)),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            appUser.lastName,
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                    color: Color.fromARGB(221, 255, 255, 255)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: queryData.size.height * 0.45),
                    child: Column(
                      children: [
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
                                        'Adress:',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Tel:',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Email:',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'My Housing co-op',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall,
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
                                        appUser.housingCooperativeAddress,
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        appUser.apartmentId,
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        appUser.tel,
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        appUser.email,
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        appUser.housingCooperative,
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(64, 50, 64, 0),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

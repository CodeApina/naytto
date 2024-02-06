import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naytto/src/constants/theme.dart';
import 'package:naytto/src/features/authentication/data/firebase_auth_repository.dart';

class DevScreen extends ConsumerWidget {
  const DevScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ColorfulSafeArea(
      color: colors(context).color2!,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                colors(context).color2!,
                colors(context).color3!,
              ])),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextButton(
                      onPressed: () {
                        // Put logic here
                      },
                      child: const Text('Button 1')),
                  TextButton(
                      onPressed: () {
                        // Put logic here
                      },
                      child: const Text('Button 2')),
                  TextButton(
                      onPressed: () {
                        // Put logic here
                      },
                      child: const Text('Button 3')),
                  TextButton(
                      onPressed: () {
                        // Put logic here
                      },
                      child: const Text('Button 4')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

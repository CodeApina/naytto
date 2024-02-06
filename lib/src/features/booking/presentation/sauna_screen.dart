import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naytto/src/constants/theme.dart';

class SaunaScreen extends ConsumerWidget {
  const SaunaScreen({super.key});

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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sauna booking',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

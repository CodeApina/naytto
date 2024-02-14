import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naytto/src/constants/theme.dart';

class LaundryScreen extends ConsumerWidget {
  const LaundryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ColorfulSafeArea(
      color: Colors.white,
      child: Scaffold(
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Laundry booking',
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

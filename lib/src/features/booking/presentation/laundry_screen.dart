import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LaundryScreen extends ConsumerWidget {
  const LaundryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        body: Center(
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
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LaundryScreen extends ConsumerWidget {
  const LaundryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Laundry booking'),
          ],
        ),
      ),
    );
  }
}

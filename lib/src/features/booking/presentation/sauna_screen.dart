import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SaunaScreen extends ConsumerWidget {
  const SaunaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Sauna booking'),
          ],
        ),
      ),
    );
  }
}

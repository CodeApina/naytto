import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naytto/src/routing/app_router.dart';

class SaunaScreen extends ConsumerWidget {
  const SaunaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            ref.read(goRouterProvider).pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Book sauna',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      body: const ColorfulSafeArea(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [],
            ),
          ),
        ),
      ),
    );
  }
}

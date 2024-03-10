import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naytto/src/features/booking/data/new_booking_repository.dart';
import 'package:naytto/src/features/booking/domain/booking.dart';
import 'package:naytto/src/routing/app_router.dart';

class MyBookingsScreen extends ConsumerWidget {
  const MyBookingsScreen({super.key});

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
            )),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'My bookings',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      body: const ColorfulSafeArea(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text('nothing here yet')],
            ),
          ),
        ),
      ),
    );
  }
}

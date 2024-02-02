import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:naytto/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:naytto/src/features/booking/presentation/booking_screen.dart';
import 'package:naytto/src/features/home/presentation/home_screen.dart';
import 'package:naytto/src/routing/go_router_refresh_stream.dart';
import 'package:naytto/src/routing/scaffold_with_navbar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:naytto/src/features/authentication/presentation/login_screen.dart';

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _bookingNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'booking');

enum AppRoute { login, home, booking }

// https://medium.com/@antonio.tioypedro1234/flutter-go-router-the-essential-guide-349ef39ec5b3
// GoRouter configuration
@riverpod
GoRouter goRouter(GoRouterRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/login',
    redirect: (context, state) {
      final path = state.uri.path;
      final isLoggedIn = authRepository.currentUser != null;
      if (isLoggedIn) {
        if (path.startsWith('/login')) {
          return '/home';
        }
      } else {
        if (path.startsWith('/home') || path.startsWith('/booking')) {
          return '/login';
        }
      }
      return null;
    },
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges()),
    routes: [
      GoRoute(
        path: '/login',
        name: AppRoute.login.name,
        pageBuilder: (context, state) => NoTransitionPage(child: LoginScreen()),
      ),
      StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return ScaffoldWithNavBar(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(navigatorKey: _homeNavigatorKey, routes: [
              GoRoute(
                name: AppRoute.home.name,
                path: '/home',
                pageBuilder: (context, state) =>
                    NoTransitionPage(child: HomeScreen()),
              )
            ]),
            StatefulShellBranch(navigatorKey: _bookingNavigatorKey, routes: [
              GoRoute(
                name: AppRoute.booking.name,
                path: '/booking',
                pageBuilder: (context, state) =>
                    NoTransitionPage(child: BookingScreen()),
              )
            ]),
          ])
    ],
  );
}

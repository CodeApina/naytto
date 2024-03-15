import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:naytto/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:naytto/src/features/authentication/domain/app_user.dart';
import 'package:naytto/src/features/booking/presentation/booking_screen.dart';
import 'package:naytto/src/features/booking/presentation/laundry_screen.dart';
import 'package:naytto/src/features/booking/presentation/my_bookings_screen.dart';
import 'package:naytto/src/features/booking/presentation/sauna_screen.dart';
import 'package:naytto/src/features/dev/dev_screen.dart';
import 'package:naytto/src/features/home/presentation/home_screen.dart';
import 'package:naytto/src/features/settings/presentation/settings_screen.dart';
import 'package:naytto/src/routing/go_router_refresh_stream.dart';
import 'package:naytto/src/routing/scaffold_with_navbar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:naytto/src/features/authentication/presentation/login_screen.dart';

part 'app_router.g.dart';

// https://medium.com/@antonio.tioypedro1234/flutter-go-router-the-essential-guide-349ef39ec5b3
// GoRouter configuration

//If your new route represents a new navigation category / shellroute stack,
// create a new GlobalKey<NavigatorState> for it
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _bookingNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'booking');
final _settingsgNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'settings');
final _devNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'dev');

// Add a new entry to the AppRoute enum for your route whether it's nested or not.
enum AppRoute {
  login,
  home,
  booking,
  sauna,
  laundry,
  settings,
  dev,
  mybookings
}

// Riverpod provider for the GoRouter instance
@riverpod
GoRouter goRouter(GoRouterRef ref) {
  // Access the authentication repository instance
  final authRepository = ref.watch(authRepositoryProvider);
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/login',
    redirect: (context, state) async {
      final path = state.uri.path;
      final isLoggedIn = authRepository.currentUser != null;
      bool isUserDataFetched = false;

      if (isLoggedIn) {
        isUserDataFetched = await AppUser().fetchUser();
      }

      if (isLoggedIn && isUserDataFetched == true) {
        if (path.startsWith('/login')) {
          return '/home';
        }
      } else {
        return '/login';
      }
      return null;
    },
    // Listens to a stream that provides information about user authentication changes
    // and automatically triggers the GoRouter to handle redirection in case the user logs out.
    // The GoRouterRefreshStream acts as a bridge, connecting the authentication state stream
    // with the GoRouter, ensuring the UI responds dynamically to changes in the user's authentication status.
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges()),
    routes: [
      // Login route, this is not part of the bottom nav bar
      GoRoute(
        path: '/login',
        name: AppRoute.login.name,
        pageBuilder: (context, state) => NoTransitionPage(child: LoginScreen()),
      ),
      // Navigation stacks for different app sections
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          // Home section with nested routes
          StatefulShellBranch(navigatorKey: _homeNavigatorKey, routes: [
            GoRoute(
              path: '/home',
              name: AppRoute.home.name,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: HomeScreen()),
            )
          ]),
          // Booking section with nested routes
          StatefulShellBranch(
            navigatorKey: _bookingNavigatorKey,
            routes: [
              GoRoute(
                path: '/booking',
                name: AppRoute.booking.name,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: BookingScreen()),
                routes: [
                  GoRoute(
                    path: 'sauna',
                    name: AppRoute.sauna.name,
                    parentNavigatorKey: _bookingNavigatorKey,
                    pageBuilder: ((context, state) {
                      return CustomTransitionPage(
                        fullscreenDialog: true,
                        child: const SaunaScreen(),
                        transitionDuration: const Duration(milliseconds: 300),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          // Define fade out animation
                          final fadeOutTween = Tween(begin: 0.0, end: 1.0);
                          final fadeOutAnimation =
                              animation.drive(fadeOutTween);

                          // Define slide in animation
                          final slideTween = Tween(
                              begin: const Offset(-1, 0),
                              end: const Offset(0, 0));
                          final slideAnimation = animation.drive(slideTween
                              .chain(CurveTween(curve: Curves.easeIn)));

                          // Apply fade transition
                          final fadeTransition = FadeTransition(
                            opacity: fadeOutAnimation,
                            child: child,
                          );

                          // Apply slide transition
                          final slideTransition = SlideTransition(
                            position: slideAnimation,
                            child: fadeTransition,
                          );

                          return slideTransition;
                        },
                      );
                    }),
                  ),
                  GoRoute(
                    path: 'laundry',
                    name: AppRoute.laundry.name,
                    parentNavigatorKey: _bookingNavigatorKey,
                    pageBuilder: (context, state) {
                      return CustomTransitionPage(
                        fullscreenDialog: true,
                        child: const LaundryScreen(),
                        transitionDuration: const Duration(milliseconds: 300),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          // Define fade out animation
                          final fadeOutTween = Tween(begin: 0.0, end: 1.0);
                          final fadeOutAnimation =
                              animation.drive(fadeOutTween);

                          // Define slide in animation
                          final slideTween = Tween(
                              begin: const Offset(-1, 0),
                              end: const Offset(0, 0));
                          final slideAnimation = animation.drive(slideTween
                              .chain(CurveTween(curve: Curves.easeIn)));

                          // Apply fade transition
                          final fadeTransition = FadeTransition(
                            opacity: fadeOutAnimation,
                            child: child,
                          );

                          // Apply slide transition
                          final slideTransition = SlideTransition(
                            position: slideAnimation,
                            child: fadeTransition,
                          );

                          return slideTransition;
                        },
                      );
                    },
                  ),
                  GoRoute(
                    path: 'mybookings',
                    name: AppRoute.mybookings.name,
                    parentNavigatorKey: _bookingNavigatorKey,
                    pageBuilder: ((context, state) {
                      return CustomTransitionPage(
                        fullscreenDialog: true,
                        child: const MyBookingsScreen(),
                        transitionDuration: const Duration(milliseconds: 300),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          // Define fade out animation
                          final fadeOutTween = Tween(begin: 0.0, end: 1.0);
                          final fadeOutAnimation =
                              animation.drive(fadeOutTween);

                          // Define slide in animation
                          final slideTween = Tween(
                              begin: const Offset(-1, 0),
                              end: const Offset(0, 0));
                          final slideAnimation = animation.drive(slideTween
                              .chain(CurveTween(curve: Curves.easeIn)));

                          // Apply fade transition
                          final fadeTransition = FadeTransition(
                            opacity: fadeOutAnimation,
                            child: child,
                          );

                          // Apply slide transition
                          final slideTransition = SlideTransition(
                            position: slideAnimation,
                            child: fadeTransition,
                          );

                          return slideTransition;
                        },
                      );
                    }),
                  )
                ],
              ),
            ],
          ),
          // Settings section with nested routes
          StatefulShellBranch(navigatorKey: _settingsgNavigatorKey, routes: [
            GoRoute(
              path: '/settings',
              name: AppRoute.settings.name,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: SettingsScreen()),
            )
          ]),
          StatefulShellBranch(navigatorKey: _devNavigatorKey, routes: [
            GoRoute(
              path: '/dev',
              name: AppRoute.dev.name,
              pageBuilder: (context, state) =>
                  NoTransitionPage(child: DevScreen()),
            )
          ]),
        ],
      )
    ],
  );
}

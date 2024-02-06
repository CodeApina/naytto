import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:naytto/src/constants/theme.dart';

/// Builds the "shell" for the app by building a Scaffold with a
/// BottomNavigationBar, where [child] is placed in the body of the Scaffold.
class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({
    required this.navigationShell,
    // required this.child,
    super.key,
  });

  /// The navigation shell and container for the branch Navigators.
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: colors(context).color3,
        selectedItemColor:
            Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
        unselectedItemColor:
            Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
        selectedLabelStyle:
            Theme.of(context).bottomNavigationBarTheme.selectedLabelStyle,
        selectedIconTheme:
            Theme.of(context).bottomNavigationBarTheme.selectedIconTheme,
        unselectedIconTheme:
            Theme.of(context).bottomNavigationBarTheme.unselectedIconTheme,
        currentIndex: navigationShell.currentIndex,
        items: <BottomNavigationBarItem>[
          // If you're adding a new navigation item to the bottom navigation bar
          // Add it here as a BottomNavigationBarItem and provide it with an icon and label
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: colors(context).color3!),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: 'Booking',
              backgroundColor: colors(context).color3!),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
              backgroundColor: colors(context).color3!),
          BottomNavigationBarItem(
              icon: Icon(Icons.developer_board),
              label: 'Dev',
              backgroundColor: colors(context).color3!),
        ],
        onTap: _onTap,
      ),
    );
  }

  void _onTap(index) {
    navigationShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This example demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}

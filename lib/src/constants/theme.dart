import 'package:flutter/material.dart';

// Theme structure done with heavy inspiration from:
// https://medium.com/@kinjal.dhamat.sa/light-dark-app-theme-with-custom-color-in-flutter-c686db585f0c

// CustomColors extension class for easy access to custom color values.
// Utilizes ThemeExtension to manage and customize colors efficiently.
CustomColors colors(context) =>
    Theme.of(context as BuildContext).extension<CustomColors>()!;

// getAppTheme function creates a ThemeData instance with a predefined light theme.
// CustomColors extension is applied to the ThemeData, allowing easy access to custom colors.
ThemeData getAppTheme(BuildContext context) {
  return ThemeData(
    extensions: const <ThemeExtension<CustomColors>>[
      CustomColors(
        color1: Color.fromARGB(255, 146, 199, 207),
        color2: Color.fromARGB(255, 170, 215, 217),
        color3: Color.fromARGB(255, 229, 249, 241),
      ),
    ],
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color.fromARGB(255, 146, 199, 207),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 170, 215, 217),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        elevation: 128,
        backgroundColor: Color.fromARGB(255, 170, 215, 217),
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black87),
    textTheme: Theme.of(context).textTheme.copyWith(
        // For headers like category names
        displayLarge: const TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        // Medium text like titles in announcements
        displayMedium: const TextStyle(
          fontSize: 28,
          color: Colors.white,
        ),
        // Main text used in announcements, booking info etc
        displaySmall: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
  );
}

// CustomColors class defines the color palette for the app, including color1, color2, and color3.
// Implements ThemeExtension<CustomColors> for efficient theme extension management.
// Provides methods for copying and interpolating color values.
@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  final Color? color1;
  final Color? color2;
  final Color? color3;

  const CustomColors({
    required this.color1,
    required this.color2,
    required this.color3,
  });

  @override
  CustomColors copyWith(
      {Color? color1, Color? color2, Color? color3, Color? color4}) {
    return CustomColors(
      color1: color1 ?? this.color1,
      color2: color2 ?? this.color2,
      color3: color3 ?? this.color3,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      color1: Color.lerp(color1, other.color1, t),
      color2: Color.lerp(color2, other.color2, t),
      color3: Color.lerp(color3, other.color3, t),
    );
  }
}

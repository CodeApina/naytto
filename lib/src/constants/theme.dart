import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        color1: Color.fromARGB(255, 255, 255, 255),
        color2: Color.fromRGBO(0, 124, 124, 1.0),
        color3: Color.fromARGB(234, 255, 255, 255),
      ),
    ],
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 170, 215, 217),
    ),
    iconTheme: const IconThemeData(
      color: Color.fromRGBO(0, 124, 124, 1.0),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      elevation: 128,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedItemColor: Colors.black,
      selectedLabelStyle: GoogleFonts.raleway(
        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
      unselectedItemColor: Colors.grey[600],
      unselectedLabelStyle: GoogleFonts.raleway(
          textStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600])),
      selectedIconTheme: const IconThemeData(
          size: 35, color: Color.fromRGBO(0, 124, 124, 1.0)),
      unselectedIconTheme: IconThemeData(color: Colors.grey[600]),
    ),
    listTileTheme: ListTileThemeData(
      textColor: Color.fromARGB(255, 14, 12, 12),
      iconColor: Color.fromRGBO(0, 124, 124, 1.0),
      titleTextStyle: GoogleFonts.raleway(
          textStyle:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      subtitleTextStyle: GoogleFonts.raleway(
          textStyle:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
    ),
    textTheme: Theme.of(context).textTheme.copyWith(
          // For headers like category names
          displayLarge: GoogleFonts.raleway(
            textStyle: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Colors.grey[900],
            ),
          ),
          // Medium text like titles in announcements
          displayMedium: GoogleFonts.raleway(
            textStyle: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          displaySmall: GoogleFonts.raleway(
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),

          //used in bookings home_screem
          titleSmall: GoogleFonts.raleway(
            textStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          bodySmall: GoogleFonts.raleway(
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          bodyMedium: GoogleFonts.raleway(
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
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

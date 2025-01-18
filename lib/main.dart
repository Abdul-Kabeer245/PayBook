import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constant/app_colors.dart';
import 'screens/home/home_screen.dart';

void main() {
  runApp(const PayBook());
}

class PayBook extends StatelessWidget {
  const PayBook({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pay Book',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primary,
            secondary: AppColors.secondary,
            surface: AppColors.background,
            error: AppColors.error,
          ),
          scaffoldBackgroundColor: AppColors.background,
          textTheme: GoogleFonts.poppinsTextTheme(
            const TextTheme(
              titleLarge: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              bodyLarge: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
              bodyMedium: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: AppColors.primary,
            iconTheme: const IconThemeData(color: AppColors.white),
            titleTextStyle: GoogleFonts.poppins(
              color: AppColors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            elevation: 0,
            centerTitle: true,
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.grey,
            backgroundColor: AppColors.white,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
          )),
      home: const HomeScreen(),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:tethr/screens/splash/index.dart' as splash;

void main() {
  runApp(MaterialApp(
    title: 'Tethr',
    theme: ThemeData(
      scaffoldBackgroundColor: Color(0xFFF9FAFB),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Color(0xFFF9FAFB),
      ),

      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: .circular(10),
          borderSide: BorderSide(width: 0.5, color: Color(0xFFE5E7EB))
        ),
        filled: true,
        fillColor: Color(0xFFF9FAFB)
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: .circular(10))),
          backgroundColor: WidgetStatePropertyAll(Color(0xFF94A3B8)),
          foregroundColor: WidgetStatePropertyAll(Colors.white),
          padding: WidgetStatePropertyAll(.symmetric(horizontal: 30, vertical: 15)),
          textStyle: WidgetStatePropertyAll(TextStyle(fontWeight: .bold, fontSize: 16))
        )
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        unselectedItemColor: Color(0xFFB5BAC3),
        selectedItemColor: Color(0xFF009689)
      )
    ),

    home: splash.Screen()
  ));
}

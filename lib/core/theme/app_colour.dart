import 'package:flutter/material.dart';

class AppColors {

  static const Color gradientDarkBlue = Color(0xFF0F2A45);
  static const Color gradientMidBlue = Color(0xFF184C81);
  static const Color gradientLightBlue = Color(0xFF1D76D1);

  static const List<Color> appGradient = [
    gradientDarkBlue,
    gradientMidBlue,
    gradientLightBlue,
  ];

  
  static const Color cardBackground = Colors.white;
  static const Color cardShadow = Color(0x22000000); 

  static const Color highPriority = Color(0xFFFF6B6B);   
  static const Color mediumPriority = Color(0xFFFFC260); 
  static const Color lowPriority = Color(0xFF4CD964);    

 
  static Color priorityBackground(Color color) {
    return color.withOpacity(0.18);
  }

  static Color getPriorityColor(int priority) {
    switch (priority) {
      case 3:
        return highPriority;
      case 2:
        return mediumPriority;
      default:
        return lowPriority;
    }
  }
}

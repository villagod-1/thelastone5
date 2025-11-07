import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const counterDisplay = TextStyle(
    fontSize: 72,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );
  
  static const motivationalMessage = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    fontStyle: FontStyle.italic,
  );
  
  static const buttonText = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const statsLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static const statsValue = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
}

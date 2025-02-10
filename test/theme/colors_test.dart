import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitcrew/theme/colors.dart';

void main() {
  test('AppColors provides correct colors', () {
    expect(AppColors.darkGreen, const Color(0xFF1E4620));
    expect(AppColors.white, Colors.white);
    expect(AppColors.black, Colors.black);
    
    expect(AppColors.loginButtonColor, AppColors.darkGreen);
    expect(AppColors.loginTextColor, AppColors.white);
    expect(AppColors.loginBackgroundColor, AppColors.black);
  });
} 
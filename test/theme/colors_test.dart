import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitcrew/theme/colors.dart';

void main() {
  test('AppColors provides correct colors', () {
    expect(AppColors.darkGreen, const Color(0xFF8A00FF));
    expect(AppColors.lightGreen, const Color(0xFFB14DFF));
    expect(AppColors.white, const Color(0xFFFFFFFF));
    expect(AppColors.black, const Color(0xFF000000));
    expect(AppColors.grey, const Color(0xFF9E9E9E));
    expect(AppColors.lightGrey, const Color(0xFFE0E0E0));
    expect(AppColors.darkGrey, const Color(0xFF424242));
    expect(AppColors.error, const Color(0xFFB00020));
  });

  test('AppColors provides correct theme colors', () {
    expect(AppColors.loginButtonColor, AppColors.darkGreen);
    expect(AppColors.loginTextColor, AppColors.white);
    expect(AppColors.loginBackgroundColor, AppColors.black);
  });
} 
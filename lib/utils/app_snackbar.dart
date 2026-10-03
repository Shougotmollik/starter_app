import 'package:shougot_flutter/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


enum SnackbarType { success, error, warning, info }

/// Global snackbar utility.
class AppSnackbar {
  AppSnackbar._();

  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void show({
    required String message,
    String? title,
    SnackbarType type = SnackbarType.info,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    final messenger = messengerKey.currentState;
    if (messenger == null) return;

    messenger.hideCurrentSnackBar();

    final (Color backgroundColor, IconData icon) = switch (type) {
      SnackbarType.success => (
        AppColors.success,
        Icons.check_circle_outline_rounded,
      ),
      SnackbarType.error => (AppColors.error, Icons.error_outline_rounded),
      SnackbarType.warning => (
        AppColors.warning,
        Icons.warning_amber_rounded,
      ),
      SnackbarType.info => (AppColors.primary, Icons.info_outline_rounded),
    };

    messenger.showSnackBar(
      SnackBar(
        duration: duration,
        behavior: SnackBarBehavior.floating,
        backgroundColor: backgroundColor,
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        padding:  EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 12.h,
        ),
        shape:  RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        action: action,
        content: Row(
          children: [
            Icon(icon, color: AppColors.white, size: 22),
             SizedBox(width: 12.w),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null) ...[
                    Text(
                      title,
                      style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                    const SizedBox(height: 2),
                  ],
                  Text(
                    message,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
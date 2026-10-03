import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

abstract class AppBootstrap {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    await _initSystemUI();
    await _initScreenUtil();
    await _initSharedPreferences();
    await _initConnectivity();
    _initErrorHandling();

    debugPrint('+++++++++++++++++++++++ AppBootstrap initialized ++++++++++++++++++++++++++++',);
  }

  static Future<void> _initSystemUI() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  static Future<void> _initScreenUtil() async {
    await ScreenUtil.ensureScreenSize();
  }

  static Future<void> _initSharedPreferences() async {
    await SharedPreferences.getInstance();
  }

  static Future<void> _initConnectivity() async {
    final connectivity = Connectivity();
    await connectivity.checkConnectivity();
  }

  static void _initErrorHandling() {
    FlutterError.onError = (details) {
      debugPrint('FlutterError: ${details.exception}');
      debugPrint('StackTrace: ${details.stack}');
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      debugPrint('PlatformError: $error');
      debugPrint('StackTrace: $stack');
      return true;
    };
  }
}
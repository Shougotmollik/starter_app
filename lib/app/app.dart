import 'package:shougot_flutter/core/theme/theme.dart';
import 'package:shougot_flutter/feature/auth/view/login_view.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shougot Flutter',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const LoginView(),
      debugShowCheckedModeBanner: false,
    );
  }
}
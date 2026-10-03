import 'package:shougot_flutter/core/theme/theme.dart';
import 'package:shougot_flutter/feature/product/view/product_view.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const ProductView(),
      title: "Shougot Flutter",
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
    );
  }
}

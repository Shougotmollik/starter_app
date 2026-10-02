import 'package:api_learning/core/theme/theme.dart';
import 'package:api_learning/feature/product/view/product_view.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProductView(),
      title: "Api Learning",
      theme: AppTheme.theme,
    );
  }
}

import 'package:shougot_flutter/app/app.dart';
import 'package:shougot_flutter/app/app_bootstrap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  await AppBootstrap.init();
  runApp(ProviderScope(child: const MyApp()));
}
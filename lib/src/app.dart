import 'package:flutter/material.dart';
import 'package:reddit_walls/src/features/home/home_page.dart';
import 'package:reddit_walls/src/theme/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      restorationScopeId: 'app',
      theme: AppTheme.lightTheme(context),
      darkTheme: AppTheme.darkTheme(context),
      home: const HomePage(),
    );
  }
}

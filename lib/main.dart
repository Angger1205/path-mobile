import 'package:flutter/material.dart';
import 'package:path_mobile/routes/router.dart';
import 'package:path_mobile/ui/core/app_theme.dart';

void main() {
  runApp(const PathMobile());
}

class PathMobile extends StatelessWidget {
  const PathMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'PATH Mobile',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}

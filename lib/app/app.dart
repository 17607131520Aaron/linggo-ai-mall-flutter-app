import 'package:flutter/material.dart';

import 'router/app_router.dart';
import 'router/app_routes.dart';

class LinggoMallApp extends StatelessWidget {
  const LinggoMallApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title: 'Linggo AI Mall',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.login,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}


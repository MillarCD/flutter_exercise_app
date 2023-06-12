import 'package:eapp/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder:(context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/training',
          builder:(context, state) => const TrainingScreen(),
        )
      ]
    );

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp.router(
      title: 'Register training app',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green[900]!),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
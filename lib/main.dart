import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:eapp/controllers/training_history_controller.dart';
import 'package:eapp/controllers/exercises_controller.dart';
import 'package:eapp/controllers/selected_training_controller.dart';
import 'package:eapp/screens/screens.dart';
import 'package:eapp/themes/themes.dart';

void main() {
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<SelectedTrainingController>(create: (context) => SelectedTrainingController(),),
        ChangeNotifierProvider<ExercisesController>(create: (context) => ExercisesController(), lazy: false),
        ChangeNotifierProvider<TrainingHistoryController>(create: (context) => TrainingHistoryController(), lazy: false),
      ],
      child: const MyApp()
    )
  );
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
        ),
        GoRoute(
          path: '/training_details',
          builder:(context, state) => const TrainingDetailsScreen(),
        ),
        GoRoute(
          path: '/exercises',
          builder:(context, state) => const ExerciseScreen(),
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
      theme: LightTheme.theme,
      darkTheme: DarkTheme.theme,
      routerConfig: _router,
    );
  }
}
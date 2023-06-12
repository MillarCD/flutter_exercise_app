import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('HomeScreen'),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          print('comenzar entrenamiento');
          GoRouter.of(context).go('/training');
        },
        icon: const Icon( Icons.sports_martial_arts_sharp ),
        label: const Text('Start Training')
      ),
    );
  }
}
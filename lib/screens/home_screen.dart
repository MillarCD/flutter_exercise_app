import 'package:eapp/models/training.dart';
import 'package:eapp/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:eapp/controllers/training_controller.dart';
import 'package:eapp/persistence/db.dart';

class HomeScreen extends StatelessWidget {

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: DB().getTrainings(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return const Center(child: Icon(Icons.error_outline),);

          List<Training> trainings = snapshot.data!;
          
          return ListView.builder(
            itemCount: trainings.length,
            itemBuilder: (context, index) {
              final Training training = trainings[index];
              
              return ListTile(
                title: Text(getDate(training.start)),
                subtitle: Text("Duration: ${hoursBetweenDates(training.start, training.end)}"),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          print('comenzar entrenamiento');
          TrainingController().startTraining();
          GoRouter.of(context).go('/training');
        },
        icon: const Icon( Icons.sports_martial_arts_sharp ),
        label: const Text('Start Training')
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:eapp/controllers/training_controller.dart';
import 'package:eapp/controllers/selected_training_controller.dart';
import 'package:eapp/models/training.dart';
import 'package:eapp/utils.dart';
import 'package:eapp/persistence/db.dart';

class HomeScreen extends StatelessWidget {

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text("Exercises"),
                onTap: () => GoRouter.of(context).push('/exercises'),
              )
            ],
          )
        ],
      ),
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
                onTap: () {
                  Provider.of<SelectedTrainingController>(context, listen: false).training = training;
                  GoRouter.of(context).push('/training_details');
                },
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          print('comenzar entrenamiento');
          if (!TrainingController().isStarted) TrainingController().startTraining();
          
          GoRouter.of(context).push('/training');
        },
        icon: const Icon( Icons.sports_martial_arts_sharp ),
        label: (TrainingController().isStarted)
          ? const Text('Continue Training')
          : const Text('Start Training')
      ),
    );
  }
}
import 'package:eapp/controllers/training_history_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:eapp/controllers/training_controller.dart';
import 'package:eapp/controllers/selected_training_controller.dart';
import 'package:eapp/models/training.dart';
import 'package:eapp/utils.dart';

class HomeScreen extends StatelessWidget {

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    TrainingHistoryController trainingHistController = Provider.of<TrainingHistoryController>(context);
    List<Training> trainings = trainingHistController.trainings;

    return Scaffold(
      appBar: AppBar(
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
      body: (trainingHistController.isLoading) 
      ? const Center(child: CircularProgressIndicator())
      : ListView.builder(
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
            onLongPress: () async {
              await showDialog(
                context: context,
                builder: (context) => _DeleteTrainingDialog(
                  onPressed: () async {
                    final bool res = await trainingHistController.deleteTrainingById(training.id);
                    if (res && context.mounted) GoRouter.of(context).pop();
                  },
                )
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

class _DeleteTrainingDialog extends StatelessWidget {
  const _DeleteTrainingDialog({
    super.key,
    this.onPressed,
  });

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Delete Training?"),
      actions: [
        TextButton(
          onPressed: () => GoRouter.of(context).pop(),
          child: const Text("Cancel")
        ),
        TextButton(
          onPressed: onPressed,
          child: const Text("Delete")
        )
      ],
    );
  }
}
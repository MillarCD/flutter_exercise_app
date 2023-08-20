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

    int nextMonth = DateTime.now().month;

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

          if (nextMonth != training.start.month) {
            return _TrainingRegisteredTile(
              training: training, 
              trainingHistController: trainingHistController
            );
          }

          final String month = number2Month(nextMonth);
          nextMonth = (1 < nextMonth) ? nextMonth - 1 : 12;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Padding(
                padding: const EdgeInsets.only(
                  left: 15.0, 
                  top: 7,
                  bottom: 3,
                ),
                child: Text(
                  "$month ${training.start.year}",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary
                  ),
                ),
              ),

              _TrainingRegisteredTile(
                training: training, 
                trainingHistController: trainingHistController
              ),
            ],
          );
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          print('comenzar entrenamiento');
          TrainingController trainingController = Provider.of<TrainingController>(context, listen: false);
          if (!trainingController.isStarted) trainingController.startTraining();
          
          GoRouter.of(context).push('/training');
        },
        icon: const Icon( Icons.sports_martial_arts_sharp ),
        label: (Provider.of<TrainingController>(context, listen: false).isStarted)
          ? const Text('Continue Training')
          : const Text('Start Training')
      ),
    );
  }
}

class _TrainingRegisteredTile extends StatelessWidget {
  const _TrainingRegisteredTile({
    super.key,
    required this.training,
    required this.trainingHistController,
  });

  final Training training;
  final TrainingHistoryController trainingHistController;

  @override
  Widget build(BuildContext context) {

    final String day = number2Day(training.start.weekday);
    final String hour = numbers2Hour(training.start.hour, training.start.minute);

    return ListTile(
      title: Text("$day ${training.start.day} $hour"),
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
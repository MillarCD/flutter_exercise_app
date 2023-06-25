
import 'package:eapp/controllers/selected_training_controller.dart';
import 'package:eapp/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TrainingDetailsScreen extends StatelessWidget {

  const TrainingDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    final stController = Provider.of<SelectedTrainingController>(context);

    if (stController.isLoading) return const Center(child: CircularProgressIndicator(),);


    return Scaffold(
      appBar: AppBar(
        title: Text(getDate(stController.training!.start)),
      ),
      body: ListView.builder(
        itemCount: stController.series.length,
        itemBuilder: (context, index) {
          print("Exercises: ${stController.exercises}");
          return ListTile(
            title: Text(stController.exercises[stController.series[index].idExercise]?.name ?? 'No name'),
            subtitle: Text('${stController.series[index].weight}x${stController.series[index].repetitions}'),
          );
        },
      )
    );
  }
}
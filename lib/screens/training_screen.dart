import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:eapp/models/exercise.dart';
import 'package:eapp/controllers/stopwatch_controller.dart';
import 'package:eapp/persistence/db.dart';
import 'package:eapp/widgets/serie_form.dart';
import 'package:eapp/controllers/training_controller.dart';
import 'package:provider/provider.dart';
import 'package:eapp/controllers/training_history_controller.dart';
import 'package:eapp/models/training.dart';

class TrainingScreen extends StatelessWidget {

  const TrainingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: DB().getExercises(),

        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final List<Exercise> data = snapshot.data!;
          List<DropdownMenuEntry> entries = [
            ...data.map(
              (e) => DropdownMenuEntry(
                value: e,
                label: e.name,
              )
            )
          ];

          return SafeArea(
            child: Padding(
              padding:  const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  const _Stopwatch(),
                  const Divider(),

                  const SizedBox(height: 10,),

                  DropdownMenu(
                    label: const Text("Exercise"),
                    dropdownMenuEntries: entries,
                    onSelected:(value) {
                      TrainingController().currentExercise = value as Exercise;
                      print("Se selecciono ${value.name}");
                    },
                  ),
                  
                  const SizedBox( height: 30, ),
                  
                  const SerieForm(),
                    
                  const Expanded(
                    flex: 1,
                    child: SizedBox(
                      // child: ListView.builder(
                      //   itemBuilder: (context, index) {
                          
                      //     return ListTile(

                      //     );
                      //   },
                      // ),
                    )
                  ),
                    
                  Center(
                    child: FilledButton(
                      onPressed: () async {

                        final bool? res = await showDialog(context: context, builder: (context) => const _EndTrainingDialog(),) as bool?;
                        if (res == null || !res) return;

                        final Training? newTraining = await TrainingController().endTraining();

                        if (newTraining!=null && context.mounted) {
                          Provider.of<TrainingHistoryController>(context, listen: false).addTraining(newTraining);
                          GoRouter.of(context).pop();
                        };
                      }, 
                      child: const SizedBox(
                        width: double.infinity,
                        child: Center(child: Text('Finish Training', style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal)))
                      )
                    ),
                  )
                ],
              ),
            ),
          );
        },
        
        
      ),
    );
  }
}

class _EndTrainingDialog extends StatelessWidget {
  const _EndTrainingDialog({super.key});

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: const Text('Finish and Save Training?'),
      actions: [
        TextButton(
          onPressed: () => GoRouter.of(context).pop(),
          child: const Text('Cancel'),
        ),

        TextButton(
          onPressed: () => GoRouter.of(context).pop(true),
          child: const Text('Accept')
        )
      ],
    );
  }
}

class _Stopwatch extends StatelessWidget {
  const _Stopwatch({super.key});

  @override
  Widget build(BuildContext context) {

    final StopwatchController swController = Provider.of<StopwatchController>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
            child: Text(
              swController.stopwatch,
              style: const TextStyle(fontSize: 62),
            ),
            onPressed: () {
              if (swController.started) {
                swController.stop();
                return;
              } 
              swController.start();
            },
          ),
        ),

        IconButton(
          iconSize: 42,
          onPressed: () {
            swController.reset();
          },
          icon: const Icon(Icons.restart_alt_rounded)
        ),
      ],
    );
  }
}
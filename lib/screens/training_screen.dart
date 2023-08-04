import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:eapp/models/series.dart';
import 'package:eapp/controllers/exercises_controller.dart';
import 'package:eapp/models/exercise.dart';
import 'package:eapp/controllers/stopwatch_controller.dart';
import 'package:eapp/controllers/training_controller.dart';
import 'package:eapp/controllers/training_history_controller.dart';
import 'package:eapp/models/training.dart';
import 'package:eapp/widgets/serie_form.dart';
import 'package:eapp/widgets/discart_training_dialog.dart';
import 'package:eapp/widgets/number_text_form_field.dart';

class TrainingScreen extends StatelessWidget {

  const TrainingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    TrainingController trainController = Provider.of<TrainingController>(context);
    ExercisesController exercisesController = Provider.of<ExercisesController>(context);
    List<DropdownMenuEntry> entries = [
      ...exercisesController.exercises.map(
        (e) => DropdownMenuEntry(
          value: e,
          label: e.name,
        )
      )
    ];
    final TextEditingController weightController = TextEditingController();
    final TextEditingController repetitionsController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon( Icons.delete_outline ),
            onPressed: () async {
              final bool discart = await showDialog(
                context: context,
                builder: (context) => const DiscartTrainingDialog()
              ) as bool? ?? false;

              if (discart && context.mounted) {
                trainController.discartTraining();
                GoRouter.of(context).pop();
              }
            },
          )
        ],
      ),
      body: SafeArea(
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
                  trainController.currentExercise = value as Exercise;
                },
              ),
              
              const SizedBox( height: 30, ),
              
              SerieForm(
                weightController: weightController,
                repetitionsController: repetitionsController,
                onsubmitted: () {
                  final double weight = double.parse(weightController.text);
                  final int repetitions = int.parse(repetitionsController.text);
                  bool res = Provider.of<TrainingController>(context, listen: false).addSeries(weight, repetitions);
    
                  if (!res) return;
    
                  print("unfocus");
                  // FocusScope.of(context).unfocus();
                  weightController.clear();
                  repetitionsController.clear();
                },
              ),

              const SizedBox(height: 10,),
              const Divider(),
                
              Expanded(
                flex: 1,
                child: SizedBox(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: trainController.series.length,
                    itemBuilder: (context, index) {
                      Series s = trainController.series[index];
                      Exercise exercise = exercisesController.getExerciseById(s.idExercise);

                      return ListTile(
                        title: Text(exercise.name, style: const TextStyle(fontSize: 17),),
                        subtitle: Text("${s.weight} Kg x ${s.repetitions} Reps"),
                        trailing: IconButton(
                          icon: const Icon( Icons.edit_outlined),
                          onPressed: () async {
                            final TextEditingController weightController = TextEditingController(); 
                            final TextEditingController repetitionsController = TextEditingController();

                            final bool? res = await showDialog(
                              context: context,
                              builder: (context) => _EditSeriesDialog(
                                  repetitionsController: repetitionsController,
                                  weightController: weightController,
                                )
                              );

                            if (res == null) return;
                            
                            if (res) {
                              final double weight = double.parse(weightController.text);
                              final int repetitions = int.parse(repetitionsController.text);

                              trainController.updateSeries(s, weight, repetitions);
                              print('editar series');
                              return;
                            }

                            trainController.deleteSeriesByHashcode(s.hashCode);
                          },
                        ),
                      );
                    },
                  ),
                )
              ),
                
              Center(
                child: FilledButton(
                  onPressed: () async {

                    final bool? res = await showDialog(context: context, builder: (context) => const _EndTrainingDialog(),) as bool?;
                    if (res == null || !res) return;

                    final Training? newTraining = await trainController.endTraining();

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
      )
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

class _EditSeriesDialog extends StatelessWidget {
  const _EditSeriesDialog({
    super.key, 
    required this.weightController, 
    required this.repetitionsController, 
  });

  final TextEditingController weightController;
  final TextEditingController repetitionsController;

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Edit Series"),
          IconButton(
            onPressed: () {
              return GoRouter.of(context).pop(false);
            },
            icon: const Icon(Icons.delete_outline)
          )
        ],
      ),
      content: SizedBox(
        height: 60,
        child: Form(
          key: formKey,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: NumberTextFormField(label: 'Weight', controller: weightController)
              ),
        
              const SizedBox(
                width: 20,
                child: Center(child: Text('X')),
              ),
        
              Expanded(
                flex: 1,
                child: NumberTextFormField(label: 'Repetitions', controller: repetitionsController,),
              ),
            ]
          )
        ),
      ),

      actions: [
        TextButton(
          onPressed: () => GoRouter.of(context).pop(),
          child: const Text("Cancel")
        ),

        TextButton(
          onPressed: () {
            if (formKey.currentState?.validate() ?? false) { 
              // if (onSaved != null) onSaved!();
              return GoRouter.of(context).pop(true);
            }
          },
          child: const Text("Save")
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
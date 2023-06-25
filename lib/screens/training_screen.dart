import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:eapp/models/exercise.dart';
import 'package:eapp/persistence/db.dart';
import 'package:eapp/widgets/serie_form.dart';
import 'package:eapp/controllers/training_controller.dart';

class TrainingScreen extends StatelessWidget {

  const TrainingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
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
        
                  Expanded(
                    flex: 1,
                    child: Container()
                  ),
        
                  Center(
                    child: FilledButton(
                      onPressed: () {
                        print('Terminar rutina');
                        TrainingController().endTraining();
                        GoRouter.of(context).go('/');
                      }, 
                      child: const Text('End Training', style: TextStyle(fontSize: 21, fontWeight: FontWeight.normal))
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
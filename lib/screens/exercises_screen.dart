import 'package:eapp/models/exercise.dart';
import 'package:eapp/persistence/db.dart';
import 'package:flutter/material.dart';

class ExerciseScreen extends StatelessWidget {

  const ExerciseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: FutureBuilder(
        future: DB().getExercises(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return const Center(child: Text("Something went wrong"),);

          List<Exercise> exercises = snapshot.data!;

          return ListView.separated(
            itemCount: exercises.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final Exercise exercise = exercises[index];

              return ListTile(
                title: Text(exercise.name)
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // TODO: desplegar modal para añadir ejercicio
        },
      ),
    );
  }
}
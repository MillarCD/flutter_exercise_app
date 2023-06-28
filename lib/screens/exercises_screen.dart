import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:eapp/controllers/exercises_controller.dart';
import 'package:eapp/models/exercise.dart';

class ExerciseScreen extends StatelessWidget {

  const ExerciseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final ExercisesController exercisesController = Provider.of<ExercisesController>(context);
    bool isLoading = exercisesController.isLoading;
    List<Exercise> exercises = exercisesController.exercises;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Exercises"),
      ),
      body: (isLoading)
        ? const Center(child: CircularProgressIndicator())
        : ListView.separated(
          itemCount: exercises.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final Exercise exercise = exercises[index];

            return ListTile(
              title: Text(exercise.name),
              onLongPress: () async {
                TextEditingController controller = TextEditingController();
                await showDialog(
                  context: context,
                  builder: (context) => _ExerciseDialog(
                    controller: controller,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Edit Exercise'),
                        IconButton(
                          icon: const Icon(Icons.delete_outlined, size: 25,),
                          onPressed: () async {
                            final bool res = await exercisesController.deleteExercise(exercise.id);
                            if (res && context.mounted) GoRouter.of(context).pop();
                          },
                        )
                      ],
                    ),
                    labelText: "New name",
                    onPressed: () async {
                      String newName = controller.text;
                      print("newName: $newName");
                      if (controller.text == '') return;
                      final bool res = await exercisesController.updateExercise(Exercise(id: exercise.id, name: newName));
                      
                      if (res && context.mounted) GoRouter.of(context).pop();
                    },
                  ),
                );
              },
            );
          },
        ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          TextEditingController controller = TextEditingController();
          await showDialog(
            context: context,
            builder: (context) => _ExerciseDialog(
              controller: controller,
              title: const Text("Create Exercise"),
              labelText: "Name",
              onPressed: () async {
                if (controller.text == '') return;
                final bool res = await exercisesController.createExercise(controller.text);
                if (!res) return;
                
                if (context.mounted) GoRouter.of(context).pop();
              },
            ),
          );
        },
      ),
    );
  }
}

class _ExerciseDialog extends StatelessWidget {
  const _ExerciseDialog({
    super.key,
    required this.controller,
    this.onPressed,
    this.title,
    required this.labelText,
  });

  final TextEditingController controller;
  final void Function()? onPressed;
  final Widget? title;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      content: TextField(
        controller: controller,
          decoration: InputDecoration(
            label: Text(labelText),
            border: const OutlineInputBorder(),
          ),
      ),
      actions: [
        TextButton(
          onPressed: () => GoRouter.of(context).pop(),
          child: const Text("Cancel")
        ),
        TextButton(
          onPressed: onPressed,
          child: const Text("Save")
        )
      ],
    );
  }
}
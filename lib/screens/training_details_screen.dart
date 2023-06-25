import 'package:eapp/controllers/selected_training_controller.dart';
import 'package:eapp/models/series.dart';
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
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Colors.transparent,
        title: Text(getDate(stController.training!.start)),
      ),
      body: ListView.separated(
        itemCount: stController.series.length,
        separatorBuilder:(context, index) => const Divider(),
        itemBuilder: (context, index) {

          List<Series> series = stController.series[index];
          String exerciseName = stController.exercises[series[0].idExercise]?.name ?? 'No name';

          return _CustomListView(exerciseName: exerciseName, series: series);
        },
      )
    );
  }
}

class _CustomListView extends StatefulWidget {
  const _CustomListView({
    super.key,
    required this.exerciseName,
    required this.series,
  });

  final String exerciseName;
  final List<Series> series;

  @override
  State<_CustomListView> createState() => _CustomListViewState();
}

class _CustomListViewState extends State<_CustomListView> {

  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget.exerciseName,
        style: const TextStyle(fontSize: 19),
      ),
      dense: true,
      onTap: () {
        isSelected = !isSelected;
        setState(() {});
      } ,
      subtitle: !isSelected ? Text(
          'Series: ${widget.series.length}',
          style: const TextStyle(fontSize: 15),
        ) 
        :
        Card(
          color: Theme.of(context).colorScheme.secondary,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...widget.series.map((s) {
                  return Text(
                    "${s.weight.toString().padLeft(6)} kg x ${s.repetitions} rep",
                    style: const TextStyle(fontSize: 15),
                  );
                })
              ],
            ),
          )
        ),
    );
  }
}
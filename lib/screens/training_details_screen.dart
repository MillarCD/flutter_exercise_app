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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _CardRow(
                  'Kg', 'Reps', '1RM',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10,),

                ...widget.series.map((s) => _CardRow(
                  s.weight.toString(),
                  s.repetitions.toString(), 
                  calcOneRM(s.weight, s.repetitions).toStringAsFixed(1),
                  style: const TextStyle(fontSize: 15),
                )),
              ],
            ),
          )
        ),
    );
  }
}

class _CardRow extends StatelessWidget {
  const _CardRow(this.text1, this.text2, this.text3, {
    super.key,
    this.style
  });

  final String text1;
  final String text2;
  final String text3;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _CardRowText(text: text1, style: style),
        _CardRowText(text: text2, style: style),
        _CardRowText(text: text3, style: style)
      ],
    );
  }
}

class _CardRowText extends StatelessWidget {
  const _CardRowText({
    super.key,
    required this.text,
    required this.style,
  });

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Center(child: Text(text, style: style,)));
  }
}
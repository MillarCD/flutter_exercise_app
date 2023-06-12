import 'package:eapp/widgets/serie_form.dart';
import 'package:flutter/material.dart';

class TrainingScreen extends StatelessWidget {

  const TrainingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    const  List<DropdownMenuEntry> entries = [
      DropdownMenuEntry(value: 1, label: 'hello'),
      DropdownMenuEntry(value: 2, label: 'world'),
      DropdownMenuEntry(value: 3, label: 'drop'),
      DropdownMenuEntry(value: 4, label: 'down'),
    ];
    
    
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:  const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DropdownMenu(
                dropdownMenuEntries: entries
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
                  }, 
                  child: const Text('End Training', style: TextStyle(fontSize: 21, fontWeight: FontWeight.normal))
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

import 'package:eapp/controllers/training_controller.dart';
import 'package:eapp/models/series.dart';

class SerieForm extends StatelessWidget {
  const SerieForm({super.key});


  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController weightController = TextEditingController();
    TextEditingController repetitionsController = TextEditingController();

    return Form(
      key: formKey,
      child: Row(
        children: [

          Expanded(
            flex: 1,
            child: _CustomTextFormField(label: 'Weight', controller: weightController)
          ),

          const SizedBox(
            width: 20,
            child: Center(child: Text('X')),
          ),

          Expanded(
            flex: 1,
            child: _CustomTextFormField(label: 'Repetitions', controller: repetitionsController,),
          ),

          const SizedBox(width: 20,),

          Expanded(
            flex: 1,
            child: FilledButton.tonal(
              onPressed: () {
                print('guardar serie');
                if (formKey.currentState?.validate() ?? false) {
                  final double weight = double.parse(weightController.text);
                  final int repetitions = int.parse(repetitionsController.text);
                  bool res = TrainingController().addSeries(weight, repetitions);

                  if (!res) return;

                  FocusScope.of(context).unfocus();
                  weightController.clear();
                  repetitionsController.clear(); // = '';
                }
                print('No se guardo');
              },
              child: const Text('Register')
            ),
          )
        ],
      ),
    );
  }
}

class _CustomTextFormField extends StatelessWidget {
  const _CustomTextFormField({
    super.key,
    required this.label,
    required this.controller,
  });

  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder()
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (double.tryParse(value ?? '') != null) return null;
        return "";
      },
    );
  }
}
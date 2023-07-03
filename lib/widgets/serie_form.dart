import 'package:eapp/widgets/number_text_form_field.dart';
import 'package:flutter/material.dart';

class SerieForm extends StatelessWidget {
  const SerieForm({
    super.key, 
    required this.weightController, 
    required this.repetitionsController, 
    this.onsubmitted
  });

  final TextEditingController weightController;
  final TextEditingController repetitionsController;
  final void Function()? onsubmitted;


  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Form(
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
    
          const SizedBox(width: 16,),
    
          Expanded(
            flex: 1,
            child: FilledButton.tonal(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {                 
                  if (onsubmitted != null) onsubmitted!();
                }
              },
              child: const Text('Register')
            ),
          )
        ],
      ),
    );
  }
}
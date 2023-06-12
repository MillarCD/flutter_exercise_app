import 'package:flutter/material.dart';

class SerieForm extends StatelessWidget {
  const SerieForm({super.key});


  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Form(
      key: formKey,
      child: Row(
        children: [

          const Expanded(
            flex: 1,
            child: _CustomTextFormField(label: 'Weight')
          ),

          const SizedBox(
            width: 20,
            child: Center(child: Text('X')),
          ),

          const Expanded(
            flex: 1,
            child: _CustomTextFormField(label: 'Repetitions'),
          ),

          const SizedBox(width: 20,),

          Expanded(
            flex: 1,
            child: FilledButton.tonal(
              onPressed: () {
                print('guardar serie');
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
    required this.label
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder()
      ),
      keyboardType: TextInputType.number,
    );
  }
}
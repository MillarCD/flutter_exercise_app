
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

class DiscartTrainingDialog extends StatelessWidget {
  const DiscartTrainingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Discart Training?"),
      actions: [
        TextButton(
          onPressed: () => GoRouter.of(context).pop(false),
          child: const Text("Cancel")
        ),

        TextButton(
          onPressed: () => GoRouter.of(context).pop(true),
          child: const Text("Accept")
        ),
      ],
    );
  }
}
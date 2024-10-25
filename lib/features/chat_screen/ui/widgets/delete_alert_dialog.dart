import 'package:flutter/material.dart';
import 'package:gemini_ai/features/chat_screen/ui/provider/chat_provider.dart';
import 'package:provider/provider.dart';

class DeleteDialog extends StatelessWidget {
  const DeleteDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Delete Images',
        style: TextStyle(),
      ),
      content: const Text(
        'Are you sure you want to delete the images?',
        style: TextStyle(fontSize: 18),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel', style: TextStyle(color: Colors.blue)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Delete', style: TextStyle(color: Colors.red)),
          onPressed: () {
            Provider.of<ChatProvider>(context, listen: false)
                .setChatImages(images: []);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

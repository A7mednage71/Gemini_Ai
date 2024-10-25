import 'package:flutter/material.dart';
import 'package:gemini_ai/features/chat_screen/ui/provider/chat_provider.dart';
import 'package:gemini_ai/features/chat_screen/ui/widgets/delete_alert_dialog.dart';
import 'package:provider/provider.dart';

void deleteImagesDialog({required BuildContext context}) {
  showDialog(
    context: context,
    builder: (context) => DeleteDialog(
      title: 'Delete Images',
      subtitle: 'Are you sure you want to delete the images?',
      onDeletePressed: () {
        Provider.of<ChatProvider>(context, listen: false)
            .setChatImages(images: []);
        Navigator.of(context).pop();
      },
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:gemini_ai/core/helpers/boxes_helper.dart';
import 'package:gemini_ai/features/chat_screen/ui/provider/chat_provider.dart';
import 'package:gemini_ai/features/chat_screen/ui/widgets/delete_alert_dialog.dart';
import 'package:provider/provider.dart';

void deleteChatHistoryDialog(
    {required BuildContext context, required String chatId}) {
  showDialog(
    context: context,
    builder: (context) => DeleteDialog(
      title: 'Delete Chat History',
      subtitle: 'Are you sure you want to delete this chat history?',
      onDeletePressed: () async {
        await BoxesHelper.getChatHistoryBox().delete(chatId);
        if (context.mounted) {
          Provider.of<ChatProvider>(context, listen: false)
              .deletChatMessages(chatId: chatId);
          Navigator.of(context).pop();
        }
      },
    ),
  );
}

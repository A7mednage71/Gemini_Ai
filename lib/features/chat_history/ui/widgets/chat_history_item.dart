import 'package:flutter/material.dart';
import 'package:gemini_ai/core/utils/delete_chat_history_dialog.dart';
import 'package:gemini_ai/features/chat_history/data/models/chat_history_model.dart';

class ChatHistoryItem extends StatelessWidget {
  const ChatHistoryItem({
    super.key,
    required this.chatHistoryModel,
  });

  final ChatHistoryModel chatHistoryModel;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          child: const Icon(Icons.chat_bubble_outline),
        ),
        title: Text(chatHistoryModel.prompt),
        subtitle: Text(chatHistoryModel.response),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () {},
        ),
        onLongPress: () {
          // delete chat history
          deleteChatHistoryDialog(
              context: context, chatId: chatHistoryModel.chatId);
        },
      ),
    );
  }
}

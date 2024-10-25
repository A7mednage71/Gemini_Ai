import 'package:flutter/material.dart';
import 'package:gemini_ai/core/helpers/boxes_helper.dart';
import 'package:gemini_ai/features/chat_history/data/models/chat_history_model.dart';
import 'package:gemini_ai/features/chat_screen/ui/widgets/delete_alert_dialog.dart';

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
          showDialog(
            context: context,
            builder: (context) => DeleteDialog(
              title: 'Delete Chat History',
              subtitle: 'Are you sure you want to delete this chat history?',
              onDeletePressed: () async {
                await BoxesHelper.getChatHistoryBox()
                    .delete(chatHistoryModel.chatId);
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              },
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gemini_ai/core/utils/delete_chat_history_dialog.dart';
import 'package:gemini_ai/features/chat_history/data/models/chat_history_model.dart';
import 'package:gemini_ai/features/chat_screen/ui/provider/chat_provider.dart';
import 'package:provider/provider.dart';

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
          radius: 22.r,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          child: const Icon(Icons.chat_bubble_outline),
        ),
        title: Text(
          chatHistoryModel.prompt,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
        ),
        subtitle:
            Text(chatHistoryModel.response, style: TextStyle(fontSize: 13.sp)),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () async {
            //  prepare chat history model to send to
            //chat screen and fill list of chat messages
            final chatProvider =
                Provider.of<ChatProvider>(context, listen: false);
            await chatProvider.prepareChatRoom(
                chatId: chatHistoryModel.chatId, isNew: false);
            // to navigate to chat screen
            chatProvider.setCurrentIndex(index: 1);
            chatProvider.pageController.jumpToPage(1);
          },
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

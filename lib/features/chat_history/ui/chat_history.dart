import 'package:flutter/material.dart';
import 'package:gemini_ai/core/helpers/boxes_helper.dart';
import 'package:gemini_ai/core/theme/theme_provider.dart';
import 'package:gemini_ai/features/chat_history/data/models/chat_history_model.dart';
import 'package:gemini_ai/features/chat_history/ui/widgets/chat_history_item.dart';
import 'package:gemini_ai/features/chat_history/ui/widgets/empty_chat_history.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class ChatHistory extends StatelessWidget {
  const ChatHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat History'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
            icon: Icon(Provider.of<ThemeProvider>(context).isDarkTheme
                ? Icons.light_mode
                : Icons.dark_mode),
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: BoxesHelper.getChatHistoryBox().listenable(),
        builder: (context, Box<ChatHistoryModel> chatHistoryBox, _) {
          return chatHistoryBox.isEmpty
              ? const EmptyChatHistory()
              : ListView.builder(
                  itemCount: chatHistoryBox.length,
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  itemBuilder: (context, index) {
                    ChatHistoryModel chatHistoryModel =
                        chatHistoryBox.values.toList()[index];
                    return ChatHistoryItem(chatHistoryModel: chatHistoryModel);
                  },
                );
        },
      ),
    );
  }
}

// ValueListenableBuilder is used to listen for changes
// in the Box<ChatHistory> (Hive box) that stores the chat history.

// Boxes.getChatHistory().listenable() provides a ValueListenable
// that notifies listeners when the data changes.
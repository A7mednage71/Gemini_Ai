import 'package:flutter/material.dart';
import 'package:gemini_ai/features/chat_screen/data/models/message_model.dart';
import 'package:gemini_ai/features/chat_screen/ui/provider/chat_provider.dart';
import 'package:gemini_ai/features/chat_screen/ui/widgets/assistant_message.dart';
import 'package:gemini_ai/features/chat_screen/ui/widgets/chat_text_input_field.dart';
import 'package:gemini_ai/features/chat_screen/ui/widgets/no_messages_in_chat.dart';
import 'package:gemini_ai/features/chat_screen/ui/widgets/user_message.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

// Function to scroll to the bottom
  void _scrollToBottom() {
    // Ensure the ListView is rendered before performing the scroll action
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // checks if the ScrollController is currently attached to a scroll view
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Chat With Gemini'),
        ),
        body: Consumer<ChatProvider>(builder: (context, chatProvider, child) {
          // Scroll to the bottom when new messages are added
          chatProvider.chatMessages.isNotEmpty ? _scrollToBottom() : null;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: chatProvider.chatMessages.isNotEmpty
                      ? ListView.builder(
                          controller: _scrollController,
                          itemCount: chatProvider.chatMessages.length,
                          itemBuilder: (context, index) {
                            var message = chatProvider.chatMessages[index];
                            return message.role == Role.user
                                ? UserMessage(message: message)
                                : AssistantMessage(message: message);
                          },
                        )
                      : const NoChatMessages(),
                ),
                ChatTextInputField(chatProvider: chatProvider),
                const SizedBox(height: 10),
              ],
            ),
          );
        }));
  }
}

import 'package:flutter/material.dart';
import 'package:gemini_ai/features/chat_screen/ui/provider/chat_provider.dart';
import 'package:gemini_ai/features/chat_screen/ui/widgets/chat_text_input_field.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Chat With Gemini'),
          centerTitle: true,
        ),
        body: Consumer<ChatProvider>(builder: (context, chatProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: chatProvider.chatMessages.isNotEmpty
                      ? ListView.builder(
                          itemCount: chatProvider.chatMessages.length,
                          itemBuilder: (context, index) {
                            var message = chatProvider.chatMessages[index];
                            return ListTile(
                              title: Text(message.message.toString()),
                              subtitle: Text(message.timeSent.toString()),
                            );
                          },
                        )
                      : const Center(child: Text("No Messages Yet")),
                ),
                ChatTextInputField(chatProvider: chatProvider),
                const SizedBox(height: 10),
              ],
            ),
          );
        }));
  }
}

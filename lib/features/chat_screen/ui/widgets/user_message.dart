import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gemini_ai/features/chat_screen/data/models/message_model.dart';

class UserMessage extends StatelessWidget {
  const UserMessage({super.key, required this.message});
  final MessageModel message;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.all(10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(18),
          ),
        ),
        child: MarkdownBody(
          selectable: true,
          data: message.message.toString(),
          styleSheet: MarkdownStyleSheet(
            p: const TextStyle(
              fontSize: 17,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

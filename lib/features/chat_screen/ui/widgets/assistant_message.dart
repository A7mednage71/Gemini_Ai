import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gemini_ai/features/chat_screen/data/models/message_model.dart';

class AssistantMessage extends StatelessWidget {
  const AssistantMessage({super.key, required this.message});
  final MessageModel message;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.all(10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.errorContainer,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomRight: Radius.circular(18),
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

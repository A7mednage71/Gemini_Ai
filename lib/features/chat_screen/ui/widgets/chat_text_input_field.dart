import 'package:flutter/material.dart';
import 'package:gemini_ai/features/chat_screen/ui/provider/chat_provider.dart';

class ChatTextInputField extends StatefulWidget {
  const ChatTextInputField({
    super.key,
    required this.chatProvider,
  });
  final ChatProvider chatProvider;
  @override
  State<ChatTextInputField> createState() => _ChatTextInputFieldState();
}

class _ChatTextInputFieldState extends State<ChatTextInputField> {
  late TextEditingController textController;
  late FocusNode focusNode;

  @override
  void initState() {
    textController = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          InkWell(
            onTap: () {},
            child: const Icon(Icons.image),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: textController,
              focusNode: focusNode,
              decoration: const InputDecoration(
                hintText: 'Type Your Prompt..',
                border: InputBorder.none,
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Transform.rotate(
                    angle: -0.7,
                    child: const Icon(Icons.send, color: Colors.white)),
              ),
            ),
          ),
          const SizedBox(width: 5),
        ],
      ),
    );
  }
}

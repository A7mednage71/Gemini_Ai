import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gemini_ai/features/chat_screen/ui/provider/chat_provider.dart';
import 'package:gemini_ai/features/chat_screen/ui/widgets/delete_alert_dialog.dart';
import 'package:gemini_ai/features/chat_screen/ui/widgets/preview_picked_images.dart';

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

  Future<void> sendMessage({required bool isTextOnly}) async {
    if (textController.text.isNotEmpty) {
      try {
        log("Message: ${textController.text}");
        await widget.chatProvider.sendMessageToGemini(
          message: textController.text,
          isTextOnly: isTextOnly,
        );
      } on Exception catch (e) {
        log("Error: $e");
      } finally {
        textController.clear();
        widget.chatProvider.setChatImages(images: []);
        focusNode.unfocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // check if there are images in the list or not
    bool hasImages = widget.chatProvider.imagesFileList != null &&
        widget.chatProvider.imagesFileList!.isNotEmpty;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          if (hasImages) const PreviewPickedImages(),
          Row(
            children: [
              const SizedBox(width: 10),
              InkWell(
                onTap: () {
                  // if there are images in the list, clear them
                  if (hasImages) {
                    showDialog(
                        context: context,
                        builder: (context) => const DeleteDialog());
                  } else {
                    // else pick images
                    widget.chatProvider.pickImages();
                  }
                },
                child: Icon(hasImages ? Icons.delete_forever : Icons.image),
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
                onTap: () async {
                  // send message
                  await sendMessage(isTextOnly: hasImages ? false : true);
                },
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
        ],
      ),
    );
  }
}

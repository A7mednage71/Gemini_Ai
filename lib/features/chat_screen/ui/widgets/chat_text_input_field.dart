import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gemini_ai/core/utils/delete_images_dialog.dart';
import 'package:gemini_ai/features/chat_screen/ui/provider/chat_provider.dart';
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
        borderRadius: BorderRadius.circular(30).w,
        border: Border.all(
          color: Colors.grey,
          width: 1.w,
        ),
      ),
      child: Column(
        children: [
          if (hasImages) const PreviewPickedImages(),
          Row(
            children: [
              SizedBox(width: 10.w),
              InkWell(
                onTap: widget.chatProvider.isLoading
                    ? null
                    : () {
                        // if there are images in the list, clear them
                        if (hasImages) {
                          deleteImagesDialog(context: context);
                        } else {
                          // else pick images
                          widget.chatProvider.pickImages();
                        }
                      },
                child: Icon(hasImages ? Icons.delete_forever : Icons.image),
              ),
              SizedBox(width: 10.w),
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
                onTap: widget.chatProvider.isLoading
                    ? null
                    : () async {
                        // send message
                        await sendMessage(isTextOnly: hasImages ? false : true);
                      },
                child: Container(
                  padding: EdgeInsets.all(8.r),
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
              SizedBox(width: 5.w),
            ],
          ),
        ],
      ),
    );
  }
}

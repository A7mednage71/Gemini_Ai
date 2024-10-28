import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gemini_ai/features/chat_screen/data/models/message_model.dart';
import 'package:gemini_ai/features/chat_screen/ui/widgets/preview_picked_images.dart';

class UserMessage extends StatelessWidget {
  const UserMessage({super.key, required this.message});
  final MessageModel message;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.all(15.r),
        margin: EdgeInsets.all(10.r),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18).w,
            topRight: const Radius.circular(18).w,
            bottomLeft: const Radius.circular(18).w,
          ),
        ),
        child: Column(
          children: [
            if (message.imagesUrls.isNotEmpty)
              PreviewPickedImages(messageModel: message),
            MarkdownBody(
              selectable: true,
              data: message.message.toString(),
              styleSheet: MarkdownStyleSheet(
                p: TextStyle(
                  fontSize: 16.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

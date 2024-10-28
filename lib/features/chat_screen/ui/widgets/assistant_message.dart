import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gemini_ai/features/chat_screen/data/models/message_model.dart';

class AssistantMessage extends StatelessWidget {
  const AssistantMessage({super.key, required this.message});
  final MessageModel message;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(15.r),
        margin: EdgeInsets.all(10.r),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18).w,
            topRight: const Radius.circular(18).w,
            bottomRight: const Radius.circular(18).w,
          ),
        ),
        child: message.message.isEmpty
            ? SizedBox(
                width: 50.w,
                child: SpinKitThreeBounce(
                  color: Colors.blueGrey,
                  size: 20.0.sp,
                ),
              )
            : MarkdownBody(
                selectable: true,
                data: message.message.toString(),
                styleSheet: MarkdownStyleSheet(
                  p: TextStyle(fontSize: 16.sp),
                ),
              ),
      ),
    );
  }
}

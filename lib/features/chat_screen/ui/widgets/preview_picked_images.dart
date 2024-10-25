import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gemini_ai/features/chat_screen/data/models/message_model.dart';
import 'package:gemini_ai/features/chat_screen/ui/provider/chat_provider.dart';
import 'package:provider/provider.dart';

class PreviewPickedImages extends StatelessWidget {
  const PreviewPickedImages({
    super.key,
    this.messageModel,
  });
  final MessageModel? messageModel;
  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(builder: (_, chatProvider, child) {
      final images = messageModel != null
          ? messageModel!.imagesUrls
          : chatProvider.imagesFileList;
      return SizedBox(
        height: 100,
        child: ListView.builder(
          itemCount: images!.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.file(
                  File(messageModel != null
                      ? messageModel!.imagesUrls[index]
                      : chatProvider.imagesFileList![index].path),
                  height: 100,
                  width: 100,
                  fit: BoxFit.fill,
                ),
              ),
            );
          },
        ),
      );
    });
  }
}

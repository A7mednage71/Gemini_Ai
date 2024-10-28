import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gemini_ai/features/chat_screen/ui/provider/chat_provider.dart';
import 'package:provider/provider.dart';

void addNewChatDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const AddNewChat(),
  );
}

class AddNewChat extends StatelessWidget {
  const AddNewChat({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
        side: const BorderSide(color: Colors.grey),
      ),
      title: const Text(
        'Add New Chat',
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      content: Text(
        'Are you sure you want to add a new chat?',
        style: TextStyle(fontSize: 18.sp),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel', style: TextStyle(color: Colors.blue)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Add', style: TextStyle(color: Colors.red)),
          onPressed: () {
            Navigator.of(context).pop();
            Provider.of<ChatProvider>(context, listen: false).prepareChatRoom(
              chatId: '',
              isNew: true,
            );
          },
        ),
      ],
    );
  }
}

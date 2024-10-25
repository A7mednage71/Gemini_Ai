import 'package:flutter/material.dart';
import 'package:gemini_ai/core/helpers/app_assets.dart';
import 'package:gemini_ai/features/chat_screen/ui/provider/chat_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class EmptyChatHistory extends StatelessWidget {
  const EmptyChatHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            AppAssets.emptyHistoryLottie,
            height: 200,
            fit: BoxFit.cover,
          ),
          const Text(
            "No chat history found !",
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () async {
              //  prepare chat history model to send to
              //chat screen and fill list of chat messages
              final chatProvider =
                  Provider.of<ChatProvider>(context, listen: false);
              await chatProvider.prepareChatRoom(chatId: '', isNew: true);
              // to navigate to chat screen
              chatProvider.setCurrentIndex(index: 1);
              chatProvider.pageController.jumpToPage(1);
            },
            child: const Text(
              "Start new chat!",
              style: TextStyle(fontSize: 18, color: Colors.blue),
            ),
          )
        ],
      ),
    );
  }
}

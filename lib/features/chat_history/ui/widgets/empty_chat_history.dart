import 'package:flutter/material.dart';
import 'package:gemini_ai/core/helpers/app_assets.dart';
import 'package:lottie/lottie.dart';

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
        ],
      ),
    );
  }
}

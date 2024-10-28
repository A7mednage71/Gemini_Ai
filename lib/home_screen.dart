import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gemini_ai/features/chat_history/ui/chat_history.dart';
import 'package:gemini_ai/features/chat_screen/ui/chat_screen.dart';
import 'package:gemini_ai/features/chat_screen/ui/provider/chat_provider.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // page view controller
  PageController pageController = PageController(initialPage: 1);
  // App features
  List<Widget> features = [
    const ChatHistory(),
    const ChatScreen(),
  ];

  // current screen index
  int currentIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatprovider, _) {
        return Scaffold(
          body: PageView(
            controller: chatprovider.pageController,
            children: features,
            onPageChanged: (value) {
              chatprovider.setCurrentIndex(index: value);
            },
          ),
          bottomNavigationBar: NavigationBar(
            height: 60.h,
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            onDestinationSelected: (index) {
              chatprovider.setCurrentIndex(index: index);
              chatprovider.pageController.jumpToPage(index);
            },
            selectedIndex: chatprovider.currentIndex,
            elevation: 0,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.history),
                label: 'History',
              ),
              NavigationDestination(
                icon: Icon(Icons.chat),
                label: 'Chat',
              ),
            ],
          ),
        );
      },
    );
  }
}

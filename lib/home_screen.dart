import 'package:flutter/material.dart';
import 'package:gemini_ai/features/chat_history/ui/chat_history.dart';
import 'package:gemini_ai/features/chat_screen/ui/chat_screen.dart';
import 'package:gemini_ai/features/profile_screen/ui/profile_screen.dart';

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
    const ProfileScreen()
  ];

  // current screen index
  int currentIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        children: features,
        onPageChanged: (value) {
          setState(() {
            currentIndex = value;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
          pageController.jumpToPage(index);
        },
        currentIndex: currentIndex,
        elevation: 0,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

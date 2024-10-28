import 'package:flutter/material.dart';
import 'package:gemini_ai/core/theme/app_theme.dart';
import 'package:gemini_ai/core/theme/theme_provider.dart';
import 'package:gemini_ai/features/chat_screen/ui/provider/chat_provider.dart';
import 'package:gemini_ai/home_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ChatProvider.initHive();
  await ThemeProvider.initHive();
  runApp(const GeminiAiApp());
}

class GeminiAiApp extends StatelessWidget {
  const GeminiAiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Gemini AI',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.isDarkTheme
                ? AppTheme.darkTheme
                : AppTheme.lightTheme,
            home: const MyHomePage(),
          );
        },
      ),
    );
  }
}

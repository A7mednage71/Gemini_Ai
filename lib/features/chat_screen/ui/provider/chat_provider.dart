import 'package:flutter/widgets.dart';
import 'package:gemini_ai/core/constant/hive_boxes.dart';
import 'package:gemini_ai/features/chat_history/data/models/chat_history_model.dart';
import 'package:gemini_ai/features/chat_screen/data/models/message_model.dart';
import 'package:gemini_ai/features/profile_screen/data/models/settings.dart';
import 'package:gemini_ai/features/profile_screen/data/models/user_model.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as path;

class ChatProvider extends ChangeNotifier {
  // chat messages
  final List<MessageModel> _chatMessages = [];
  List<XFile>? images = [];
  // page controller for the page view
  final PageController _pageController = PageController();
  int currentIndex = 0;
  // current chat id
  String currentChatId = '';
  // generative model for the chat
  GenerativeModel? _generativeModel;
  // generative model for the text
  GenerativeModel? _textModel;
  // generative model for the vision
  GenerativeModel? _visionModel;
  // current mode
  final String _modelType = 'gemini-pro';
  // loading bool
  bool isLoading = false;

  // getters
  List<MessageModel> get chatMessages => _chatMessages;
  List<XFile>? get getImages => images;

  PageController get pageController => _pageController;
  int get getCurrentIndex => currentIndex;
  String get getCurrentChatId => currentChatId;

  GenerativeModel? get generativeModel => _generativeModel;
  GenerativeModel? get textModel => _textModel;
  GenerativeModel? get visionModel => _visionModel;

  bool get getIsLoading => isLoading;

  static Future<void> initHive() async {
    // find the right path to store the database
    var dir = await path.getApplicationDocumentsDirectory();

    // initialize Hive
    await Hive.initFlutter(dir.path);

    // register adapters for the models
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ChatHistoryModelAdapter());
      await Hive.openBox<ChatHistoryModel>(HiveBoxes.chatHistoryBox);
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(UserModelAdapter());
      await Hive.openBox<UserModel>(HiveBoxes.userBox);
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(SettingsAdapter());
      await Hive.openBox<Settings>(HiveBoxes.settingsBox);
    }
  }
}

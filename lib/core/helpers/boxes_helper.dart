import 'package:gemini_ai/core/constant/hive_boxes.dart';
import 'package:gemini_ai/features/chat_history/data/models/chat_history_model.dart';
import 'package:gemini_ai/features/profile_screen/data/models/settings.dart';
import 'package:gemini_ai/features/profile_screen/data/models/user_model.dart';
import 'package:hive/hive.dart';

class BoxesHelper {
  static Box<UserModel> getUserBox() => Hive.box<UserModel>(HiveBoxes.userBox);

  static Box<Settings> getSettingsBox() =>
      Hive.box<Settings>(HiveBoxes.settingsBox);

  static Box<ChatHistoryModel> getChatHistoryBox() =>
      Hive.box<ChatHistoryModel>(HiveBoxes.chatHistoryBox);
}

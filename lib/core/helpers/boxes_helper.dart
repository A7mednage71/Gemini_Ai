import 'package:gemini_ai/core/constant/hive_boxes.dart';
import 'package:gemini_ai/features/chat_history/data/models/chat_history_model.dart';
import 'package:hive/hive.dart';

class BoxesHelper {
  static Box<ChatHistoryModel> getChatHistoryBox() =>
      Hive.box<ChatHistoryModel>(HiveBoxes.chatHistoryBox);
}

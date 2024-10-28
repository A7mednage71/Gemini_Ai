import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:gemini_ai/core/constant/hive_boxes.dart';
import 'package:gemini_ai/core/helpers/boxes_helper.dart';
import 'package:gemini_ai/core/networking/api_constants.dart';
import 'package:gemini_ai/features/chat_history/data/models/chat_history_model.dart';
import 'package:gemini_ai/features/chat_screen/data/models/message_model.dart';
import 'package:gemini_ai/features/profile_screen/data/models/settings.dart';
import 'package:gemini_ai/features/profile_screen/data/models/user_model.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:uuid/uuid.dart';

class ChatProvider extends ChangeNotifier {
  // chat messages
  final List<MessageModel> _inChatMessages = [];
  List<XFile>? imagesFileList = [];
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
  String _modelType = 'gemini-pro';
  // loading bool
  bool isLoading = false;

  // getters
  List<MessageModel> get chatMessages => _inChatMessages;
  List<XFile>? get getImages => imagesFileList;

  PageController get pageController => _pageController;
  int get getCurrentIndex => currentIndex;
  String get getCurrentChatId => currentChatId;

  GenerativeModel? get generativeModel => _generativeModel;
  GenerativeModel? get textModel => _textModel;
  GenerativeModel? get visionModel => _visionModel;

  bool get getIsLoading => isLoading;

  // set current chat old messages to inchatmessages
  Future<void> setInChatMessages({required String chatId}) async {
    final messages = await getChatMessagesFromHive(chatId: chatId);
    for (var message in messages) {
      if (!_inChatMessages.contains(message)) {
        _inChatMessages.add(message);
      }
    }
    notifyListeners();
  }

  // get chat messages from hive
  Future<List<MessageModel>> getChatMessagesFromHive(
      {required String chatId}) async {
    await Hive.openBox('${HiveBoxes.chatMessagesBox}$chatId');
    var chatMessagesBox = Hive.box('${HiveBoxes.chatMessagesBox}$chatId');

    final messages = chatMessagesBox.keys.map((key) {
      final message = chatMessagesBox.get(key);
      return MessageModel.fromMap(Map<String, dynamic>.from(message));
    }).toList();

    notifyListeners();
    return messages;
  }

  // set generative model based on current model type [gemini-1.0-pro, gemini-1.5-flash]
  Future<void> setGenerativeModel({required bool isTextOnly}) async {
    if (isTextOnly) {
      _generativeModel = _textModel ??
          GenerativeModel(
            model: setCurrentModel(model: 'gemini-1.0-pro'),
            apiKey: ApiConstants.apiKey,
            generationConfig: GenerationConfig(
              temperature: 0.4,
              topK: 32,
              topP: 1,
              maxOutputTokens: 4096,
            ),
            safetySettings: [
              SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high),
              SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high),
            ],
          );
    } else {
      _generativeModel = _visionModel ??
          GenerativeModel(
            model: setCurrentModel(model: 'gemini-1.5-flash'),
            apiKey: ApiConstants.apiKey,
            generationConfig: GenerationConfig(
              temperature: 0.4,
              topK: 32,
              topP: 1,
              maxOutputTokens: 4096,
            ),
            safetySettings: [
              SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high),
              SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high),
            ],
          );
    }
    notifyListeners();
  }

  // prepare chat Room
  Future<void> prepareChatRoom(
      {required String chatId, required bool isNew}) async {
    if (!isNew) {
      // if old get old messages from DB and
      // add them to inChatMessages after clearing it
      final messages = await getChatMessagesFromHive(chatId: chatId);
      _inChatMessages.clear();
      for (var message in messages) {
        _inChatMessages.add(message);
      }
      // set current chat id to the old chat id
      setCurrentChatId(chatId: chatId);
    } else {
      // if new create new chat
      _inChatMessages.clear();
      // set current chat id to  ''
      setCurrentChatId(chatId: chatId);
    }
  }

  // send message to chat
  Future<void> sendMessageToGemini(
      {required String message, required bool isTextOnly}) async {
    // set generative model
    await setGenerativeModel(isTextOnly: isTextOnly);
    // set loading
    setLoading(loadingState: true);
    // get chat id
    String chatId = getChatId();
    // get chat history
    List<Content> history = [];
    history = await getChatConversation(chatId: chatId);

    // get images urls
    List<String> imagesUrls = await getImagesUrls(isTextOnly: isTextOnly);

    // open chat messages box
    final chatMessagesBox =
        await Hive.openBox('${HiveBoxes.chatMessagesBox}$chatId');

    // get message id
    String messageId = chatMessagesBox.keys.length.toString();
    // get assistant message id
    String assistantMessageId = (chatMessagesBox.keys.length + 1).toString();

    // create new message
    MessageModel newMessage = MessageModel(
      message: StringBuffer(message),
      messageId: messageId,
      role: Role.user,
      chatId: chatId,
      imagesUrls: imagesUrls,
      timeSent: DateTime.now(),
    );

    // add message to chat history
    _inChatMessages.add(newMessage);
    notifyListeners();
    // change chat id if it is  empty
    if (currentChatId.isEmpty) {
      setCurrentChatId(chatId: chatId);
    }

    // send message to chat

    await sendMessageToChatAndGetResponse(
      history: history,
      userMessage: newMessage,
      chatId: chatId,
      isTextOnly: isTextOnly,
      message: message,
      assistantMessageId: assistantMessageId,
      chatMessagesBox: chatMessagesBox,
    );
  }

  Future<void> sendMessageToChatAndGetResponse({
    required List<Content> history,
    required String message,
    required String chatId,
    required bool isTextOnly,
    required MessageModel userMessage,
    required String assistantMessageId,
    required Box chatMessagesBox,
  }) async {
    // start a chat session using a generative model
    // send history to gemini
    final chatSession = _generativeModel!
        .startChat(history: history.isEmpty || !isTextOnly ? null : history);

    // get content
    final content =
        await getMessageContent(message: message, isTextOnly: isTextOnly);

    // creates a new MessageModel to represent the assistant's response
    MessageModel assistantMessage = userMessage.copyWith(
      messageId: assistantMessageId,
      message: StringBuffer(), // clear message
      role: Role.assistant,
      timeSent: DateTime.now(),
    );

    // add assistant message
    _inChatMessages.add(assistantMessage);
    notifyListeners();

    // wait for assistant response to be generated
    chatSession.sendMessageStream(content).asyncMap((event) {
      return event;
    }).listen((event) {
      // locates the assistant message in _inChatMessages
      // and updates its message
      _inChatMessages
          .firstWhere((element) =>
              element.messageId == assistantMessage.messageId &&
              element.role.name == Role.assistant.name)
          .message
          .write(event.text);
      notifyListeners();
    }, onDone: () async {
      // save assistant message and user message to hive
      await saveMessageToHive(
        chatId: chatId,
        assistantMessage: assistantMessage,
        userMessage: userMessage,
        chatMessagesBox: chatMessagesBox,
      );
      log("done chat session");
      setLoading(loadingState: false);
    }).onError((erro, stackTrace) {
      log(erro.toString());
      setLoading(loadingState: false);
    });
  }

  Future<void> saveMessageToHive({
    required String chatId,
    required MessageModel assistantMessage,
    required MessageModel userMessage,
    required Box chatMessagesBox,
  }) async {
    //  add user message and assistant message to chat messages box
    await chatMessagesBox.add(userMessage.toMap());
    await chatMessagesBox.add(assistantMessage.toMap());

    // add user message and assistant message to chat history box
    // if not exists already in chat history box else update it

    final chatHistoryBox = BoxesHelper.getChatHistoryBox();

    // create chat history model
    ChatHistoryModel chatHistoryModel = ChatHistoryModel(
      chatId: chatId,
      prompt: userMessage.message.toString(),
      response: assistantMessage.message.toString(),
      imagesUrls: userMessage.imagesUrls,
      timestamp: DateTime.now(),
    );

    // add chat history model to chat history box
    await chatHistoryBox.put(chatId, chatHistoryModel);

    // close chat messages box
    await chatMessagesBox.close();
  }

  // delete chat messages from hive
  Future<void> deletChatMessages({required String chatId}) async {
    // 1. check if the box is open
    if (!Hive.isBoxOpen('${HiveBoxes.chatMessagesBox}$chatId')) {
      // open the box
      await Hive.openBox('${HiveBoxes.chatMessagesBox}$chatId');

      // delete all messages in the box
      await Hive.box('${HiveBoxes.chatMessagesBox}$chatId').clear();

      // close the box
      await Hive.box('${HiveBoxes.chatMessagesBox}$chatId').close();
    } else {
      // delete all messages in the box
      await Hive.box('${HiveBoxes.chatMessagesBox}$chatId').clear();

      // close the box
      await Hive.box('${HiveBoxes.chatMessagesBox}$chatId').close();
    }

    // get the current chatId, its its not empty
    // we check if its the same as the chatId
    // if its the same we set it to empty
    if (currentChatId.isNotEmpty) {
      if (currentChatId == chatId) {
        setCurrentChatId(chatId: '');
        _inChatMessages.clear();
        notifyListeners();
      }
    }
  }

  Future<Content> getMessageContent(
      {required String message, required bool isTextOnly}) async {
    if (isTextOnly) {
      // generate text from input message
      return Content.text(message.toString());
    } else {
      // generate image from input message
      // handles both text and images in this case

      // 0 - To work with the image data in a format suitable for processing or sending over a network
      // 1-  converting each image into byte data
      final images = imagesFileList
          ?.map(
            (image) => image.readAsBytes(),
          )
          .toList(growable: false);

      // 2- waits for all image reading operations to complete
      final imagesBytes = await Future.wait(images!);

      // 3- creates a list of DataPart objects, where each image is represented in image/jpeg format
      // DataPart : package the byte data along with other information,
      // such as the file type (in this case, 'image/jpeg'),
      // Each DataPart represents an individual image with its byte data and its format.
      final imagesParts = imagesBytes
          .map((bytes) => DataPart('image/jpeg', Uint8List.fromList(bytes)))
          .toList();

      // 4- converts the input string message into a TextPart
      final prompt = TextPart(message);

      return Content.multi([prompt, ...imagesParts]);
    }
  }

  Future<List<String>> getImagesUrls({required bool isTextOnly}) async {
    List<String> imagesUrls = [];
    if (!isTextOnly && imagesFileList != null) {
      for (var image in imagesFileList!) {
        imagesUrls.add(image.path);
      }
    }
    return imagesUrls;
  }

  /// it's important to send the full conversation context,
  /// so the model understands the current chat and can respond coherently.
  Future<List<Content>> getChatConversation({required String chatId}) async {
    List<Content> history = [];
    // get chat messages if chat id is not empty
    if (currentChatId.isNotEmpty) {
      await setInChatMessages(chatId: chatId);
      // add messages to history
      for (var message in _inChatMessages) {
        if (message.role == Role.user) {
          history.add(Content.text(message.message.toString()));
        } else {
          history.add(Content.model([TextPart(message.message.toString())]));
        }
      }
    }
    return history;
  }

  /// set current chat id by uuid if it is empty
  /// or it is the first time to send message in this chat
  /// else return current chat id
  String getChatId() {
    if (currentChatId == '' || currentChatId.isEmpty) {
      return const Uuid().v4();
    } else {
      return currentChatId;
    }
  }

  // set current model
  String setCurrentModel({required String model}) {
    _modelType = model;
    notifyListeners();
    return _modelType;
  }

  // set Xfiles images
  void setChatImages({required List<XFile> images}) {
    imagesFileList = images;
    notifyListeners();
  }

  // set current index
  void setCurrentIndex({required int index}) {
    currentIndex = index;
    log("Current Index: $currentIndex");
    notifyListeners();
  }

  // set current chat id
  void setCurrentChatId({required String chatId}) {
    currentChatId = chatId;
    notifyListeners();
  }

  // set loading
  void setLoading({required bool loadingState}) {
    isLoading = loadingState;
    notifyListeners();
  }

  // pick multiple image
  Future<void> pickImages() async {
    final List<XFile> images = await ImagePicker().pickMultiImage(
      imageQuality: 95,
      maxHeight: 800,
      maxWidth: 800,
    );
    setChatImages(images: images);
  }

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

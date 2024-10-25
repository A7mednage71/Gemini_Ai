class MessageModel {
  String messageId;
  String chatId;
  Role role;
  StringBuffer message;
  List<String> imagesUrls;
  DateTime timeSent;

  MessageModel({
    required this.messageId,
    required this.chatId,
    required this.role,
    required this.message,
    required this.imagesUrls,
    required this.timeSent,
  });

  // to map
  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'chatId': chatId,
      'role': role.index,
      'message': message.toString(),
      'imagesUrls': imagesUrls,
      'timeSent': timeSent,
    };
  }

  // from map
  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      messageId: map['messageId'],
      chatId: map['chatId'],
      role: Role.values[map['role']],
      message: StringBuffer(map['message']),
      imagesUrls: List<String>.from(map['imagesUrls']),
      timeSent: map['timeSent'],
    );
  }

  // copy with
  MessageModel copyWith({
    String? messageId,
    String? chatId,
    Role? role,
    StringBuffer? message,
    List<String>? imagesUrls,
    DateTime? timeSent,
  }) {
    return MessageModel(
      messageId: messageId ?? this.messageId,
      chatId: chatId ?? this.chatId,
      role: role ?? this.role,
      message: message ?? this.message,
      imagesUrls: imagesUrls ?? this.imagesUrls,
      timeSent: timeSent ?? this.timeSent,
    );
  }

  @override
  String toString() {
    return 'MessageModel(messageId: $messageId, chatId: $chatId, role: $role, message: $message, imagesUrls: $imagesUrls, timeSent: $timeSent)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MessageModel && other.messageId == messageId;
  }

  @override
  int get hashCode {
    return messageId.hashCode;
  }
}

enum Role { user, assistant }



//The role.index is used in toMap because Role is likely an enum,
// which cannot be directly stored in a map as is.
// The .index property of an enum returns its position as an integer,
// making it easier to store in a map, database, or JSON format.
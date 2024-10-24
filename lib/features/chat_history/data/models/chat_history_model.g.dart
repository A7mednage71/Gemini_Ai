// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_history_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatHistoryModelAdapter extends TypeAdapter<ChatHistoryModel> {
  @override
  final int typeId = 0;

  @override
  ChatHistoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatHistoryModel(
      chatId: fields[0] as String,
      prompt: fields[1] as String,
      response: fields[2] as String,
      imagesUrls: (fields[3] as List).cast<String>(),
      timestamp: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ChatHistoryModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.chatId)
      ..writeByte(1)
      ..write(obj.prompt)
      ..writeByte(2)
      ..write(obj.response)
      ..writeByte(3)
      ..write(obj.imagesUrls)
      ..writeByte(4)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatHistoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

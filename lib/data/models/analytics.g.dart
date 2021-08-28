// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AnalyticsAdapter extends TypeAdapter<Analytics> {
  @override
  final int typeId = 3;

  @override
  Analytics read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Analytics(
      analyticsId: fields[0] as String,
      songId: fields[1] as String,
      userId: fields[2] as String,
      duration: fields[3] as int,
      listenedAt: fields[4] as DateTime,
      location: fields[5] as String,
      createdAt: fields[6] as DateTime,
      updatedAt: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Analytics obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.analyticsId)
      ..writeByte(1)
      ..write(obj.songId)
      ..writeByte(2)
      ..write(obj.userId)
      ..writeByte(3)
      ..write(obj.duration)
      ..writeByte(4)
      ..write(obj.listenedAt)
      ..writeByte(5)
      ..write(obj.location)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnalyticsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

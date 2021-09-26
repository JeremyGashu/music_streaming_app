// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_download_task.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalDownloadTaskAdapter extends TypeAdapter<LocalDownloadTask> {
  @override
  final int typeId = 4;

  @override
  LocalDownloadTask read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalDownloadTask(
      songId: fields[0] as String,
      title: fields[1] as String,
      coverImageUrl: fields[2] as String,
      songUrl: fields[3] as String,
      duration: fields[4] as int,
      progress: fields[5] as double,
    );
  }

  @override
  void write(BinaryWriter writer, LocalDownloadTask obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.songId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.coverImageUrl)
      ..writeByte(3)
      ..write(obj.songUrl)
      ..writeByte(4)
      ..write(obj.duration)
      ..writeByte(5)
      ..write(obj.progress);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalDownloadTaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_task.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DownloadTaskAdapter extends TypeAdapter<DownloadTask> {
  @override
  final int typeId = 1;

  @override
  DownloadTask read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DownloadTask(
      track_id: fields[0] as String,
      url: fields[1] as String,
      download_path: fields[2] as String,
      segment_number: fields[3] as int,
      downloadType: fields[5] as DownloadType,
      downloaded: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, DownloadTask obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.track_id)
      ..writeByte(1)
      ..write(obj.url)
      ..writeByte(2)
      ..write(obj.download_path)
      ..writeByte(3)
      ..write(obj.segment_number)
      ..writeByte(4)
      ..write(obj.downloaded)
      ..writeByte(5)
      ..write(obj.downloadType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadTaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

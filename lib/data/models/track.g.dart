// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TrackAdapter extends TypeAdapter<Track> {
  @override
  final int typeId = 5;

  @override
  Track read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Track(
      songId: fields[1] as String,
      artistId: fields[3] as String,
      title: fields[5] as String,
      coverImageUrl: fields[6] as String,
      songUrl: fields[7] as String,
      isSingle: fields[8] as bool,
      genreId: fields[9] as String,
      views: fields[11] as int,
      duration: fields[12] as int,
      lyricsLocation: fields[13] as String,
      imageLocation: fields[14] as String,
      trackLocation: fields[15] as String,
      releasedAt: fields[16] as DateTime,
      likeCount: fields[0] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Track obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.likeCount)
      ..writeByte(1)
      ..write(obj.songId)
      ..writeByte(3)
      ..write(obj.artistId)
      ..writeByte(5)
      ..write(obj.title)
      ..writeByte(6)
      ..write(obj.coverImageUrl)
      ..writeByte(7)
      ..write(obj.songUrl)
      ..writeByte(8)
      ..write(obj.isSingle)
      ..writeByte(9)
      ..write(obj.genreId)
      ..writeByte(11)
      ..write(obj.views)
      ..writeByte(12)
      ..write(obj.duration)
      ..writeByte(13)
      ..write(obj.lyricsLocation)
      ..writeByte(14)
      ..write(obj.imageLocation)
      ..writeByte(15)
      ..write(obj.trackLocation)
      ..writeByte(16)
      ..write(obj.releasedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrackAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

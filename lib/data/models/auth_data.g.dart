// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AuthDataAdapter extends TypeAdapter<AuthData> {
  @override
  final int typeId = 1;

  @override
  AuthData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AuthData(
      isAuthenticated: fields[0] as bool,
      phone: fields[1] as String,
      token: fields[2] as String,
      message: fields[3] as String,
      refreshToken: fields[4] as String,
      userId: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AuthData obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.isAuthenticated)
      ..writeByte(1)
      ..write(obj.phone)
      ..writeByte(2)
      ..write(obj.token)
      ..writeByte(3)
      ..write(obj.message)
      ..writeByte(4)
      ..write(obj.refreshToken)
      ..writeByte(5)
      ..write(obj.userId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

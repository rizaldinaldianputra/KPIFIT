// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 2;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      nama: fields[0] as String,
      email: fields[1] as String,
      noHp: fields[2] as String,
      jabatan: fields[3] as String,
      dinas: fields[4] as String,
      divisi: fields[5] as String,
      username: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.nama)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.noHp)
      ..writeByte(3)
      ..write(obj.jabatan)
      ..writeByte(4)
      ..write(obj.dinas)
      ..writeByte(5)
      ..write(obj.divisi)
      ..writeByte(6)
      ..write(obj.username);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

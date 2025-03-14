// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'olahraga.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SportModelAdapter extends TypeAdapter<SportModel> {
  @override
  final int typeId = 1;

  @override
  SportModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SportModel(
      id: fields[0] as String?,
      nama: fields[1] as String?,
      icon: fields[2] as String?,
      gif: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SportModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nama)
      ..writeByte(2)
      ..write(obj.icon)
      ..writeByte(3)
      ..write(obj.gif);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SportModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkoutModelAdapter extends TypeAdapter<WorkoutModel> {
  @override
  final int typeId = 0;

  @override
  WorkoutModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkoutModel(
      tanggal: fields[0] as String,
      lokasi: fields[1] as String,
      sport: fields[2] as SportModel,
      timer: fields[3] as String,
      latitude: fields[4] as double,
      longitude: fields[5] as double,
      imagePaths: (fields[6] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.tanggal)
      ..writeByte(1)
      ..write(obj.lokasi)
      ..writeByte(2)
      ..write(obj.sport)
      ..writeByte(3)
      ..write(obj.timer)
      ..writeByte(4)
      ..write(obj.latitude)
      ..writeByte(5)
      ..write(obj.longitude)
      ..writeByte(6)
      ..write(obj.imagePaths);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

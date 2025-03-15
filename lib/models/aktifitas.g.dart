// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aktifitas.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AktivitasModelAdapter extends TypeAdapter<AktivitasModel> {
  @override
  final int typeId = 0;

  @override
  AktivitasModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AktivitasModel(
      id: fields[0] as int?,
      nik: fields[1] as String,
      nama: fields[2] as String,
      namaOlahraga: fields[3] as String,
      tanggal: fields[4] as String,
      totalWaktu: fields[5] as String,
      lokasi: fields[6] as String,
      foto: fields[7] as String,
      lampiran: fields[8] as String,
      status: fields[9] as int,
      submitDate: fields[10] as String,
      latitude: fields[11] as double,
      longitude: fields[12] as double,
    );
  }

  @override
  void write(BinaryWriter writer, AktivitasModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nik)
      ..writeByte(2)
      ..write(obj.nama)
      ..writeByte(3)
      ..write(obj.namaOlahraga)
      ..writeByte(4)
      ..write(obj.tanggal)
      ..writeByte(5)
      ..write(obj.totalWaktu)
      ..writeByte(6)
      ..write(obj.lokasi)
      ..writeByte(7)
      ..write(obj.foto)
      ..writeByte(8)
      ..write(obj.lampiran)
      ..writeByte(9)
      ..write(obj.status)
      ..writeByte(10)
      ..write(obj.submitDate)
      ..writeByte(11)
      ..write(obj.latitude)
      ..writeByte(12)
      ..write(obj.longitude);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AktivitasModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

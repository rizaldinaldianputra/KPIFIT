import 'package:hive/hive.dart';

part 'aktifitas.g.dart';

@HiveType(typeId: 0)
class AktivitasModel extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  final String nik;

  @HiveField(2)
  final String nama;

  @HiveField(3)
  final String namaOlahraga;

  @HiveField(4)
  final String tanggal;

  @HiveField(5)
  final String totalWaktu;

  @HiveField(6)
  final String lokasi;

  @HiveField(7)
  final String foto;

  @HiveField(8)
  final String lampiran;

  @HiveField(9)
  final int status;

  @HiveField(10)
  final String submitDate;

  @HiveField(11)
  final double latitude;

  @HiveField(12)
  final double longitude;

  AktivitasModel({
    this.id,
    required this.nik,
    required this.nama,
    required this.namaOlahraga,
    required this.tanggal,
    required this.totalWaktu,
    required this.lokasi,
    required this.foto,
    required this.lampiran,
    required this.status,
    required this.submitDate,
    required this.latitude,
    required this.longitude,
  });

  factory AktivitasModel.fromJson(Map<String, dynamic> json) {
    return AktivitasModel(
      id: json['id'],
      nik: json['nik'] ?? '',
      nama: json['nama'] ?? '',
      namaOlahraga: json['namaolahraga'] ?? '',
      tanggal: json['tanggal'] ?? '',
      totalWaktu: json['totalwaktu'] ?? '',
      lokasi: json['lokasi'] ?? '',
      foto: json['foto'] ?? '',
      lampiran: json['lampiran'] ?? '',
      status: json['status'] ?? 0,
      submitDate: json['submitdate'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nik': nik,
      'nama': nama,
      'namaolahraga': namaOlahraga,
      'tanggal': tanggal,
      'totalwaktu': totalWaktu,
      'lokasi': lokasi,
      'foto': foto,
      'lampiran': lampiran,
      'status': status,
      'submitdate': submitDate,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory AktivitasModel.blank({int? id}) {
    return AktivitasModel(
      id: id,
      nik: '',
      nama: '',
      namaOlahraga: '',
      tanggal: '',
      totalWaktu: '',
      lokasi: '',
      foto: '',
      lampiran: '',
      status: 0,
      submitDate: '',
      latitude: 0.0,
      longitude: 0.0,
    );
  }
}

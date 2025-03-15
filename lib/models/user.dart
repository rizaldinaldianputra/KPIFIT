import 'dart:convert';
import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 2)
class UserModel extends HiveObject {
  @HiveField(0)
  String nama;

  @HiveField(1)
  String email;

  @HiveField(2)
  String noHp;

  @HiveField(3)
  String jabatan;

  @HiveField(4)
  String dinas;

  @HiveField(5)
  String divisi;

  @HiveField(6)
  String username;

  UserModel({
    this.nama = '',
    this.email = '',
    this.noHp = '',
    this.jabatan = '',
    this.dinas = '',
    this.divisi = '',
    this.username = '',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      nama: json['Nama'] ?? '',
      email: json['Email'] ?? '',
      noHp: json['No. HP'] ?? '',
      jabatan: json['Jabatan'] ?? '',
      dinas: json['Dinas'] ?? '',
      divisi: json['Divisi'] ?? '',
      username: json['Username'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Nama': nama,
      'Email': email,
      'No. HP': noHp,
      'Jabatan': jabatan,
      'Dinas': dinas,
      'Divisi': divisi,
      'Username': username,
    };
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }

  static UserModel fromJsonString(String jsonString) {
    return UserModel.fromJson(jsonDecode(jsonString));
  }

  static UserModel blank() {
    return UserModel();
  }
}

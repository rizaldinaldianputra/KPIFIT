import 'dart:convert';

class UserModel {
  String nama;
  String email;
  String noHp;
  String jabatan;
  String dinas;
  String divisi;
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

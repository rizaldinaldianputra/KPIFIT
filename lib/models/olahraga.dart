import 'package:hive/hive.dart';

part 'olahraga.g.dart';

@HiveType(typeId: 1) // Gunakan typeId yang unik
class SportModel extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? nama;

  @HiveField(2)
  String? icon;

  @HiveField(3)
  String? gif;

  SportModel({this.id, this.nama, this.icon, this.gif});

  factory SportModel.fromJson(Map<String, dynamic> json) {
    return SportModel(
      id: json['id'],
      nama: json['nama'],
      icon: json['icon'],
      gif: json['gif'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'icon': icon,
      'gif': gif,
    };
  }

  static SportModel blank() {
    return SportModel(
      id: '',
      nama: '',
      icon: '',
      gif: '',
    );
  }
}

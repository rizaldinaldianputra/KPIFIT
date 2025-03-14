import 'package:hive/hive.dart';
import 'package:kpifit/models/olahraga.dart';

part 'workout.g.dart';

@HiveType(typeId: 0) // Set typeId unik
class WorkoutModel extends HiveObject {
  @HiveField(0)
  String tanggal;

  @HiveField(1)
  String lokasi;

  @HiveField(2)
  SportModel sport;

  @HiveField(3)
  String timer;

  @HiveField(4)
  double latitude;

  @HiveField(5)
  double longitude;

  @HiveField(6)
  List<String> imagePaths;

  WorkoutModel({
    required this.tanggal,
    required this.lokasi,
    required this.sport,
    required this.timer,
    required this.latitude,
    required this.longitude,
    required this.imagePaths,
  });

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    return WorkoutModel(
      tanggal: json['tanggal'],
      lokasi: json['lokasi'],
      sport: SportModel.fromJson(Map<String, dynamic>.from(json['sport'])),
      timer: json['timer'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      imagePaths: List<String>.from(json['imagePaths']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tanggal': tanggal,
      'lokasi': lokasi,
      'sport': sport.toJson(),
      'timer': timer,
      'latitude': latitude,
      'longitude': longitude,
      'imagePaths': imagePaths,
    };
  }
}

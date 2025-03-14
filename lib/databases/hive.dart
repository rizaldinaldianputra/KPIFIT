import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kpifit/models/olahraga.dart';
import 'package:kpifit/models/workout.dart';

class HiveService {
  static late Box<WorkoutModel> _box;

  /// **Inisialisasi Hive**
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(WorkoutModelAdapter());
    Hive.registerAdapter(SportModelAdapter());

    _box = await Hive.openBox<WorkoutModel>('workoutBox');
  }

  /// **Simpan WorkoutModel ke Hive**
  static Future<void> saveWorkoutData(WorkoutModel workout) async {
    await _box.add(workout);
  }

  /// **Ambil Semua WorkoutModel dari Hive**
  static List<WorkoutModel> loadWorkoutData() {
    return _box.values.toList();
  }

  /// **Hapus WorkoutModel berdasarkan index**
  static Future<void> removeWorkoutData(int index) async {
    await _box.deleteAt(index);
  }

  /// **Perbarui WorkoutModel berdasarkan index**
  static Future<void> updateWorkoutData(int index, WorkoutModel workout) async {
    await _box.putAt(index, workout);
  }

  /// **Hapus Semua Data**
  static Future<void> clearData() async {
    await _box.clear();
  }

  /// **Cek Data Setelah Restart**
  static void checkData() {
    print('Data setelah restart: ${_box.values.toList()}');
  }
}

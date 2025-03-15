import 'package:hive_flutter/hive_flutter.dart';
import 'package:kpifit/models/aktifitas.dart';
import 'package:kpifit/models/olahraga.dart';
import 'package:kpifit/models/user.dart';

class HiveService {
  static late Box<AktivitasModel> _boxAktivitas;
  static late Box<SportModel> _boxSport;
  static late Box<UserModel> _boxUsers;

  /// **Inisialisasi Hive**
  static Future<void> init() async {
    await Hive.initFlutter();

    try {
      if (!Hive.isAdapterRegistered(UserModelAdapter().typeId)) {
        Hive.registerAdapter(UserModelAdapter());
      }
      if (!Hive.isAdapterRegistered(SportModelAdapter().typeId)) {
        Hive.registerAdapter(SportModelAdapter());
      }
      if (!Hive.isAdapterRegistered(AktivitasModelAdapter().typeId)) {
        Hive.registerAdapter(AktivitasModelAdapter());
      }
    } catch (e) {}

    _boxAktivitas = await Hive.openBox<AktivitasModel>('aktivitasBox');
    _boxSport = await Hive.openBox<SportModel>('sportBox');
    _boxUsers = await Hive.openBox<UserModel>('usersBox');
  }

  static UserModel? loadUsersData() {
    if (!_boxUsers.isOpen) {
      print("Box Users belum terbuka");
      return null;
    }
    var user = _boxUsers.get('currentUser');
    print("User yang di-load: ${user?.nama}");
    return user;
  }

  static Future<void> saveSportData(SportModel sport) async {
    if (!_boxSport.isOpen) return;

    // Cek apakah data sudah ada berdasarkan 'id' atau properti unik lainnya
    bool isExist = _boxSport.values.any((s) => s.id == sport.id);

    if (!isExist) {
      await _boxSport.add(sport);
    }
  }

  static List<SportModel> loadSportData() {
    return _boxSport.isOpen ? _boxSport.values.toList() : [];
  }

  /// **Hapus Data Olahraga berdasarkan index**
  static Future<void> removeSportData(int index) async {
    if (!_boxSport.isOpen) return;
    await _boxSport.deleteAt(index);
  }

  /// **Perbarui Data Olahraga berdasarkan index**
  static Future<void> updateSportData(int index, SportModel sport) async {
    if (!_boxSport.isOpen) return;
    await _boxSport.putAt(index, sport);
  }

  /// **Hapus Semua Data Olahraga**
  static Future<void> clearDataSport() async {
    if (!_boxSport.isOpen) return;
    await _boxSport.clear();
  }

  /// **Simpan Data Aktivitas**
  static Future<void> saveWorkoutData(AktivitasModel aktivitas) async {
    if (!_boxAktivitas.isOpen) return;
    await _boxAktivitas.add(aktivitas);
  }

  /// **Ambil Semua Data Aktivitas**
  static List<AktivitasModel> loadWorkoutData() {
    return _boxAktivitas.isOpen ? _boxAktivitas.values.toList() : [];
  }

  /// **Hapus Data Aktivitas berdasarkan index**
  static Future<void> removeWorkoutData(int index) async {
    if (!_boxAktivitas.isOpen) return;
    await _boxAktivitas.deleteAt(index);
  }

  /// **Perbarui Data Aktivitas berdasarkan index**
  static Future<void> updateWorkoutData(
      int index, AktivitasModel aktivitas) async {
    if (!_boxAktivitas.isOpen) return;
    await _boxAktivitas.putAt(index, aktivitas);
  }

  /// **Hapus Semua Data Aktivitas**
  static Future<void> clearDataWorkOut() async {
    if (!_boxAktivitas.isOpen) return;
    await _boxAktivitas.clear();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kpifit/databases/hive.dart';
import 'package:kpifit/models/aktifitas.dart';
import 'package:kpifit/models/olahraga.dart';
import 'package:kpifit/models/user.dart';
import 'package:kpifit/service/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoPag extends ConsumerStatefulWidget {
  const LogoPag({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LogoPagState();
}

class _LogoPagState extends ConsumerState<LogoPag> {
  @override
  void initState() {
    initialSeason();
    getSport();
    super.initState();
  }

  void getSport() async {
    List<SportModel> result = await CoreService(context).fetchOlahragaList();
    var existingData = HiveService.loadSportData(); // Ambil data dari Hive

    for (var element in result) {
      if (!existingData.contains(element)) {
        await HiveService.saveSportData(element);
      }
    }
  }

  Future<void> initialSeason() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final String? nik = sharedPreferences.getString('nik');

    if (nik == null || nik.isEmpty) {
      if (mounted) context.goNamed('login');
    } else {
      if (mounted) context.goNamed('home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/logo.png'),
      ),
    );
  }
}

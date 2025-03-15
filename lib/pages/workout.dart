import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kpifit/databases/hive.dart';
import 'package:kpifit/pages/aktifitas/all_aktifitas.dart';
import 'package:kpifit/pages/aktifitas/pending_aktifitas.dart';

class WorkOutPage extends ConsumerStatefulWidget {
  const WorkOutPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WorkOutPageState();
}

class _WorkOutPageState extends ConsumerState<WorkOutPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _initialize() async {
    await HiveService.init();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _initialize();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue, // Background biru
      appBar: AppBar(
        title: const Text('Workout', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        elevation: 0,
        bottom: TabBar(
          dividerColor: Colors.transparent,
          controller: _tabController,
          indicator: const BoxDecoration(), // Hilangkan indikator
          labelColor: Colors.white, // Warna teks saat aktif
          unselectedLabelColor:
              Colors.white.withOpacity(0.6), // Warna teks saat tidak aktif
          tabs: const [
            Tab(text: "All"),
            Tab(text: "Pending"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [AllWorkoutPage(), PendingWorkoutPage()],
      ),
    );
  }
}

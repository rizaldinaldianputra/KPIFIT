import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kpifit/config/colors.dart';
import 'package:kpifit/databases/hive.dart';
import 'package:kpifit/models/aktifitas.dart';
import 'package:kpifit/util/widget_button.dart';

class PendingWorkoutPage extends ConsumerStatefulWidget {
  const PendingWorkoutPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PendingWorkoutPageState();
}

class _PendingWorkoutPageState extends ConsumerState<PendingWorkoutPage> {
  List<AktivitasModel> workouts = [];

  @override
  void initState() {
    HiveService.init();
    super.initState();
    _loadWorkoutData();
  }

  Future<void> _loadWorkoutData() async {
    final data = await HiveService.loadWorkoutData();
    if (data != null) {
      setState(() {
        workouts = data.map((e) => e as AktivitasModel).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: workouts.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Container(
              margin: const EdgeInsets.symmetric(horizontal: 14),
              width: double.infinity,
              child: ListView.builder(
                itemCount: workouts.length,
                itemBuilder: (context, index) {
                  final workout = workouts[index];

                  return GestureDetector(
                    onTap: () {
                      context.goNamed('detail',
                          extra: workout,
                          queryParameters: {
                            'index': index.toString(),
                            'show': 'A'
                          });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(width: 0.5, color: Colors.grey),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.sports_soccer,
                                    color: primaryColor,
                                  ),
                                  const SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        workout.namaOlahraga,
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        workout.totalWaktu,
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Icon(
                                Icons.navigate_next_rounded,
                                size: 30,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: button('Sync Upload', _loadWorkoutData, secondaryColor),
      ),
    );
  }
}

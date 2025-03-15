import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:kpifit/config/colors.dart';
import 'package:kpifit/databases/hive.dart';
import 'package:kpifit/models/aktifitas.dart';
import 'package:kpifit/models/olahraga.dart';
import 'package:kpifit/models/user.dart';
import 'package:kpifit/service/services.dart';
import 'package:kpifit/util/function.dart';

class BerandaPage extends ConsumerStatefulWidget {
  final UserModel? userModel;
  const BerandaPage({super.key, required this.userModel});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BerandaPageState();
}

class _BerandaPageState extends ConsumerState<BerandaPage> {
  String formattedDateTime = '';
  List<SportModel> listOlahRaga = [];
  List<AktivitasModel> listAktifis = [];
  Timer? _timer; // Tambahkan referensi timer

  @override
  void initState() {
    super.initState();
    getSport();

    getAktifitas();
    _updateDateTime();
  }

  void dispose() {
    _timer?.cancel(); // Batalkan timer saat widget dihapus
    super.dispose();
  }

  void _updateDateTime() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        formattedDateTime =
            DateFormat('EEEE, dd MMMM yyyy | HH:mm:ss').format(DateTime.now());
      });
    });
  }

  Future<void> getSport() async {
    final data = await HiveService.loadSportData();
    if (data != null) {
      setState(() {
        listOlahRaga = data.map((e) => e as SportModel).toList();
      });
    }
  }

  Future<void> getAktifitas() async {
    try {
      List<AktivitasModel> result = await HiveService.loadWorkoutData();
      if (mounted) {
        setState(() => listAktifis = result);
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.32),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [HexColor('#01A2E9'), HexColor('#274896')]),
            ),
            child: Column(
              children: [
                const SizedBox(height: 35),
                _buildUserProfileSection(),
                _buildMotivationSection(),
              ],
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        color: primaryColor,
        onRefresh: () async {
          getAktifitas();
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            _buildSportGrid(),
            _buildRecentActivities(),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfileSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircleAvatar(
              radius: 20, backgroundImage: AssetImage('assets/profile.jpg')),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hello',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      color: Colors.white,
                    )),
                Text(widget.userModel?.nama ?? '',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.italic,
                      fontSize: 14,
                      color: Colors.white,
                    ))
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildMotivationSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Text('Jangan lupa berolahraga hari ini !!!',
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w300,
                  fontSize: 12,
                  color: Colors.white)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.calendar_today_outlined,
                  color: Colors.white, size: 16),
              const SizedBox(width: 10),
              Text(formattedDateTime,
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.white)),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.all(20),
            height: 40,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  onPressed: () {},
                  icon: Icon(getGreetingIcon(), color: getGreetingColor()),
                  label: Text(
                    greetingMessage(),
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      textStyle: TextStyle(
                        fontSize: 14,
                        color: false
                            ? Colors.grey
                            : Colors.black, // Sesuaikan kondisi
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSportGrid() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 0.5, color: Colors.grey),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: listOlahRaga.length,
        itemBuilder: (context, index) {
          final data = listOlahRaga[index];

          return GestureDetector(
            onTap: () {
              context.goNamed('stopwatch', extra: data);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  visible: listOlahRaga[index].gif != null &&
                      listOlahRaga[index].gif!.isNotEmpty,
                  child: Image.network(
                    listOlahRaga[index].gif!,
                    height: 30,
                    width: 30,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.broken_image,
                          size: 30, color: primaryColor);
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Text(listOlahRaga[index].nama!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecentActivities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            'Aktivitas Terbaru',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 14),
          width: double.infinity,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: listAktifis.length > 3 ? 3 : listAktifis.length,
            itemBuilder: (context, index) {
              final data = listAktifis[index];
              return GestureDetector(
                onTap: () {
                  context.goNamed('detail', extra: data, queryParameters: {
                    'index': index.toString(),
                    'status': 'D'
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(width: 0.5, color: Colors.grey),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.directions_run_rounded,
                            color: primaryColor,
                          ),
                          const SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.namaOlahraga,
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                data.tanggal,
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                data.totalWaktu + ' Menit',
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
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 50),
      ],
    );
  }
}

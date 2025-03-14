import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:kpifit/config/colors.dart';
import 'package:kpifit/models/olahraga.dart';
import 'package:kpifit/service/services.dart';

class BerandaPage extends ConsumerStatefulWidget {
  const BerandaPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BerandaPageState();
}

class _BerandaPageState extends ConsumerState<BerandaPage> {
  String formattedDateTime = '';

  @override
  void initState() {
    getOlahraga();
    super.initState();
    _updateDateTime();
  }

  void _updateDateTime() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final formatted = DateFormat('EEEE, dd MMMM yyyy | HH:mm:ss').format(now);
      if (mounted) {
        setState(() {
          formattedDateTime = formatted;
        });
      }
    });
  }

  String greetingMessage() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'Selamat Pagi';
    } else if (hour >= 12 && hour < 15) {
      return 'Selamat Siang';
    } else if (hour >= 15 && hour < 18) {
      return 'Selamat Sore';
    } else {
      return 'Selamat Malam';
    }
  }

  IconData getGreetingIcon() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return Icons.wb_sunny; // Pagi
    } else if (hour >= 12 && hour < 15) {
      return Icons.wb_sunny_outlined; // Siang
    } else if (hour >= 15 && hour < 18) {
      return Icons.wb_twighlight; // Sore
    } else {
      return Icons.nightlight_round; // Malam
    }
  }

  Color getGreetingColor() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return Colors.orange; // Pagi
    } else if (hour >= 12 && hour < 15) {
      return Colors.yellow; // Siang
    } else if (hour >= 15 && hour < 18) {
      return Colors.deepOrange; // Sore
    } else {
      return Colors.blueGrey; // Malam
    }
  }

  List<SportModel> list = [];

  Future<void> getOlahraga() async {
    try {
      List<SportModel> result = await CoreService(context).fetchOlahragaList();
      setState(() {
        list = result;
      });
    } catch (e) {
      print("Error: $e");
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
                colors: [HexColor('#01A2E9'), HexColor('#274896')],
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 35),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  width: double.infinity,
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage('assets/profile.jpg')),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w700,
                                textStyle: const TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Text(
                              'Rizaldi Naldian Putra',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w400,
                                textStyle: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 18),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        'Jangan lupa berolahraga hari ini !!!',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w300,
                          textStyle: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            formattedDateTime, // Gantilah dengan variabel yang sesuai
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              textStyle: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
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
                              icon: Icon(getGreetingIcon(),
                                  color: getGreetingColor()),
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
                ),
              ],
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            Container(
              width: double.infinity,
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
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      SportModel sportModel = SportModel();
                      sportModel.id = '2';
                      sportModel.nama = 'Basket Ball';
                      context.goNamed('stopwatch', extra: sportModel);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.widgets,
                          size: 32,
                          color: Colors.blue,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'menu ${index + 1}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                'Aktivitas Terbaru',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  textStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 14),
              width: double.infinity,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 2,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(8),
                    margin: EdgeInsets.all(5),
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
                              Icons.sports_football,
                              color: primaryColor,
                            ),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Basket Ball',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  '7 Maret 2025 07:45',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  '20  Menit 15 detik',
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
                        Icon(
                          Icons.navigate_next_rounded,
                          size: 30,
                          color: Colors.grey,
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}

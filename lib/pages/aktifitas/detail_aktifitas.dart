import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kpifit/config/colors.dart';
import 'package:kpifit/databases/hive.dart';
import 'package:kpifit/models/aktifitas.dart';
import 'package:kpifit/riverpod/home.dart';
import 'package:kpifit/service/services.dart';
import 'package:kpifit/util/widget_appbar.dart';
import 'package:kpifit/util/widget_notifikasi.dart';
import 'package:latlong2/latlong.dart';

class DetailPage extends ConsumerStatefulWidget {
  final AktivitasModel workoutModel;
  final String? index;
  final String? show;

  const DetailPage(
      {super.key,
      required this.workoutModel,
      required this.index,
      required this.show});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DetailPageState();
}

class _DetailPageState extends ConsumerState<DetailPage> {
  @override
  void initState() {
    _getAddress();
    HiveService.init();
    super.initState();
  }

  final MapController _mapController = MapController();

  String address = "Sedang mengambil alamat...";

  Future<void> _getAddress() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        widget.workoutModel.latitude,
        widget.workoutModel.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        setState(() {
          address =
              "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
        });
      } else {
        setState(() {
          address = "Alamat tidak ditemukan";
        });
      }
    } catch (e) {
      setState(() {
        address = "Gagal mendapatkan alamat";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String imagePaths = widget.workoutModel.foto;
    print(json.encode(widget.workoutModel));
    return Scaffold(
      appBar: buildGradientAppBar(context, 'Detail Aktifitas'),
      body: Column(
        children: [
          // PETA
          SizedBox(
            height: 250,
            child: LatLng(widget.workoutModel.latitude,
                        widget.workoutModel.longitude) ==
                    null
                ? const Center(child: Text("Lokasi tidak tersedia"))
                : FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: LatLng(widget.workoutModel.latitude,
                          widget.workoutModel.longitude),
                      initialZoom: 15.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                        userAgentPackageName:
                            'dev.fleaflet.flutter_map.example',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: LatLng(widget.workoutModel.latitude,
                                widget.workoutModel.longitude),
                            width: 50,
                            height: 50,
                            child: const Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),

          const SizedBox(height: 10),
          Text(
            address,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.all(20),
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
                          widget.workoutModel.namaOlahraga,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          widget.workoutModel.totalWaktu,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          widget.workoutModel.tanggal ?? '',
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
          // GALERI FOTO
          Expanded(
            child: imagePaths.isEmpty
                ? const Center(child: Text("Tidak ada gambar"))
                : (widget.show == 'A')
                    ? Padding(
                        padding: const EdgeInsets.all(20),
                        child: Image.file(
                          File(imagePaths),
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(20),
                        child: Image.network(
                          imagePaths,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
          ),

          // TOMBOL DELETE & UPLOAD
        ],
      ),
      bottomNavigationBar: Visibility(
        visible: widget.show == 'A' ? true : false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    await HiveService.removeWorkoutData(
                        int.parse(widget.index!));
                    notifikasiFailed(
                        'Data berhasil dihapus'); // Tampilkan notifikasi
                    context.goNamed('home');
                    ref.watch(homePageProvider.notifier).jumpToPage(0);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text("Delete"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    String status = await CoreService(context)
                        .uploadAktifitas(widget.workoutModel, context);
                    if (status == 'success') {
                      await HiveService.removeWorkoutData(
                          int.parse(widget.index!));
                      notifikasiLocal(
                          'Data berhasil dihapus dari local'); // Tampilkan notifikasi
                      context.goNamed('home');
                      ref.watch(homePageProvider.notifier).jumpToPage(0);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text("Upload"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

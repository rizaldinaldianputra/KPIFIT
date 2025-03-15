import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kpifit/config/colors.dart';
import 'package:kpifit/databases/hive.dart';
import 'package:kpifit/models/aktifitas.dart';
import 'package:kpifit/models/olahraga.dart';
import 'package:kpifit/service/services.dart';
import 'package:kpifit/util/widget_button.dart';
import 'package:kpifit/util/widget_notifikasi.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';
import 'package:geocoding/geocoding.dart';

class MapPage extends StatefulWidget {
  final String timer;
  final SportModel sportModel;
  const MapPage({super.key, required this.timer, required this.sportModel});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LatLng? _currentLocation;
  List<File> _images = [];
  final ImagePicker _picker = ImagePicker();
  late Box _imageBox;
  final MapController _mapController = MapController();
  String lokasiAktif = "Sedang mencari lokasi...";

  Future<void> _pickAttachment() async {
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        _images = [File(file.path)]; // Simpan hanya satu gambar terbaru
      });
      _saveImageToHive();
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _images = [File(image.path)]; // Ganti gambar lama dengan yang baru
      });
      _saveImageToHive();
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _initialize();
  }

  Future<void> _initialize() async {
    await HiveService.init();
    await _initHive();
    await _getCurrentLocation();
    _loadImages();
  }

  Future<void> _initHive() async {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    _imageBox = await Hive.openBox('images');
  }

  Future<void> _loadImages() async {
    final storedImages = _imageBox.get('photos', defaultValue: []);
    if (storedImages is List) {
      setState(() {
        _images =
            List<String>.from(storedImages).map((path) => File(path)).toList();
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });
    _mapController.move(_currentLocation!, 15.0);

    // Ambil nama lokasi dari koordinat
    await getAddressFromLatLng(position.latitude, position.longitude);
  }

  Future<void> getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      Placemark place = placemarks.first;

      String lokasi =
          "${place.subLocality}, ${place.locality}, ${place.country}";

      setState(() {
        lokasiAktif = lokasi;
      });
    } catch (e) {
      print("Error mendapatkan alamat: $e");
    }
  }

  void _saveImageToHive() {
    _imageBox.put('photos', _images.map((img) => img.path).toList());
  }

  void _deleteImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
    _saveImageToHive();
  }

  Future<bool> checkInternetAccess() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Workout',
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        flexibleSpace: Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [HexColor('#01A2E9'), HexColor('#274896')],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // PETA
          Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: _currentLocation == null
                    ? const Center(child: CircularProgressIndicator())
                    : FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          initialZoom: 15.0,
                          initialCenter: _currentLocation ??
                              LatLng(-6.2088, 106.8456), // Default ke Jakarta
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                            userAgentPackageName:
                                'dev.fleaflet.flutter_map.example',
                          ),
                          if (_currentLocation != null)
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: _currentLocation!,
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
              Positioned(
                bottom: 10,
                right: 10,
                child: FloatingActionButton(
                  onPressed: _getCurrentLocation,
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.my_location, color: Colors.blue),
                ),
              ),
            ],
          ),

          // INFO BOX
          Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(width: 0.5, color: Colors.grey),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                children: [
                  SizedBox(
                      height: 30, child: Image.network(widget.sportModel.gif!)),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        widget.sportModel.nama ?? '',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        formattedDate,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        lokasiAktif,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        widget.timer,
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
            ),
          ),

          // GALERI FOTO
          Expanded(
              child: _images.isEmpty
                  ? const Center(child: Text("Belum ada foto"))
                  : Expanded(
                      child: _images.isEmpty
                          ? const Center(child: Text("Belum ada lampiran"))
                          : Expanded(
                              child: _images.isEmpty
                                  ? const Center(
                                      child: Text("Belum ada lampiran"))
                                  : Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          Image.file(_images.first,
                                              fit: BoxFit.cover,
                                              width: double.infinity),
                                          GestureDetector(
                                            onTap: () => _deleteImage(0),
                                            child: const Icon(Icons.close,
                                                color: Colors.red),
                                          ),
                                        ],
                                      ),
                                    ),
                            ))),
        ],
      ),
      bottomNavigationBar: Row(
        children: [
          Expanded(
            child: button('Simpan', () async {
              final sportData = AktivitasModel(
                submitDate: DateTime.now().toString(),
                status: 0,
                nama: 'nama',
                nik: 'nik',
                lampiran: '',
                tanggal: DateTime.now().toString(),
                lokasi: lokasiAktif, // Nama lokasi dari koordinat
                namaOlahraga: widget.sportModel.nama ?? '',
                totalWaktu: widget.timer,
                latitude: _currentLocation?.latitude ?? 0.0,
                longitude: _currentLocation?.longitude ?? 0.0,
                foto: _images.isNotEmpty ? _images.first.path : '',
              );

              final hasInternet = await checkInternetAccess();

              if (!hasInternet) {
                // Simpan lokal jika tidak ada internet
                await HiveService.saveWorkoutData(sportData);
                notifikasiLocal('Data disimpan secara offline');
                context.goNamed('home');
              } else {
                // Upload jika ada internet
                await CoreService(context).uploadAktifitas(sportData, context);
              }
            }, primaryColor),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "btn1",
            child: const Icon(Icons.camera_alt, color: Colors.black),
            onPressed: _pickImage,
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "btn2",
            child: const Icon(Icons.attachment, color: Colors.black),
            onPressed: _pickAttachment,
          ),
        ],
      ),
    );
  }
}

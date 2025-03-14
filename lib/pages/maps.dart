import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kpifit/config/colors.dart';
import 'package:kpifit/databases/hive.dart';
import 'package:kpifit/models/olahraga.dart';
import 'package:kpifit/models/workout.dart';
import 'package:kpifit/routing/route.dart';
import 'package:kpifit/util/widget_button.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';

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

  @override
  void initState() {
    super.initState();
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
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _images.add(File(image.path));
      });
      _saveImageToHive();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          widget.sportModel.nama ?? '',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          widget.sportModel.gif ?? '',
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
            child: Column(
              children: [
                Expanded(
                  child: _images.isEmpty
                      ? const Center(child: Text("Belum ada foto"))
                      : GridView.builder(
                          padding: const EdgeInsets.all(10),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: _images.length,
                          itemBuilder: (context, index) => Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  _images[index],
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: GestureDetector(
                                  onTap: () => _deleteImage(index),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: button('Simpan', () async {
        final sportData = WorkoutModel(
          tanggal: DateTime.now().toString(),
          lokasi: 'Bogor',
          sport: widget.sportModel,
          timer: widget.timer,
          latitude: _currentLocation?.latitude ?? 0.0,
          longitude: _currentLocation?.longitude ?? 0.0,
          imagePaths: _images.map((e) => e.path).toList(),
        );

        await HiveService.saveWorkoutData(sportData);
        context.goNamed('home');
      }, primaryColor),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.camera_alt, color: Colors.black),
        onPressed: _pickImage,
      ),
    );
  }
}

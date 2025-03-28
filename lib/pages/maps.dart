import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import 'package:kpifit/riverpod/home.dart';
import 'package:kpifit/service/services.dart';
import 'package:kpifit/util/widget_button.dart';
import 'package:kpifit/util/widget_notifikasi.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';
import 'package:geocoding/geocoding.dart';

class MapPage extends ConsumerStatefulWidget {
  final String timer;
  final String latStart;
  final String longStart;
  final SportModel sportModel;

  MapPage(
      {Key? key,
      required this.timer,
      required this.sportModel,
      required this.latStart,
      required this.longStart})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  LatLng? _currentLocation;
  LatLng? _destinationLocation;
  List<File> _images = [];
  final ImagePicker _picker = ImagePicker();
  late Box _imageBox;
  final MapController _mapController = MapController();
  String lokasiAktif = "";
  double? distance;
  bool isLoading = false;
  bool _mapReady = false;

  Future<void> _pickAttachment() async {
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        _images = [File(file.path)];
      });
      _saveImageToHive();
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _images = [File(image.path)];
      });
      _saveImageToHive();
    }
  }

  double calculateDistance(LatLng start, LatLng end) {
    final Distance distance = Distance();
    return distance.as(LengthUnit.Kilometer, start, end);
  }

  @override
  void initState() {
    super.initState();
    _initialize();
    double lat = double.parse(widget.latStart);
    double long = double.parse(widget.longStart);
    _destinationLocation = LatLng(lat, long);
    _getCurrentLocation();
  }

  Future<void> _initialize() async {
    await HiveService.init();
    await _initHive();
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

    try {
      Position position = await Geolocator.getCurrentPosition();
      final newLocation = LatLng(position.latitude, position.longitude);

      setState(() {
        _currentLocation = newLocation;
        distance = calculateDistance(_currentLocation!, _destinationLocation!);
      });

      _moveMapToLocation(newLocation);

      await getAddressFromLatLng(position.latitude, position.longitude);
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  void _moveMapToLocation(LatLng location) {
    if (_mapReady && mounted) {
      _mapController.move(location, 15.0);
    }
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
      print("Tidak mendapatkan alamat:");
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
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return isLoading
        ? Scaffold(
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
            body: Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            ),
          )
        : Scaffold(
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
                                initialCenter: _currentLocation!,
                                onMapReady: () {
                                  setState(() {
                                    _mapReady = true;
                                  });
                                  _moveMapToLocation(_currentLocation!);
                                },
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate:
                                      "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                                  userAgentPackageName:
                                      'dev.fleaflet.flutter_map.example',
                                ),
                                PolylineLayer(
                                  polylines: [
                                    Polyline(
                                      points: [
                                        _currentLocation!,
                                        _destinationLocation!,
                                      ],
                                      strokeWidth: 4.0,
                                      color: Colors.red,
                                    ),
                                  ],
                                ),
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
                                    Marker(
                                      point: _destinationLocation!,
                                      width: 50,
                                      height: 50,
                                      child: const Icon(
                                        Icons.flag,
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
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FloatingActionButton(
                            heroTag: "currentLocationFab",
                            onPressed: _getCurrentLocation,
                            backgroundColor: Colors.white,
                            child: const Icon(Icons.my_location,
                                color: Colors.blue),
                          ),
                          const SizedBox(height: 10),
                          FloatingActionButton(
                            heroTag: "fullScreenMapFab",
                            onPressed: () {
                              showGeneralDialog(
                                context: context,
                                barrierDismissible: true,
                                barrierLabel: "Peta",
                                transitionDuration:
                                    const Duration(milliseconds: 300),
                                pageBuilder: (context, anim1, anim2) {
                                  return FullScreenMapDialog(
                                    //Use the new Widget
                                    currentLocation: _currentLocation,
                                    destinationLocation: _destinationLocation,
                                  );
                                },
                              );
                            },
                            backgroundColor: Colors.white,
                            child: const Icon(Icons.fullscreen,
                                color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Distance',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      Text(distance == null
                          ? "Hitung jarak"
                          : "${distance!.toStringAsFixed(2)} KM"),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey,
                ),
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
                            height: 30,
                            child: Image.network(
                              widget.sportModel.gif!,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.broken_image,
                                    size: 30, color: Colors.grey);
                              },
                            )),
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
                Expanded(
                    child: _images.isEmpty
                        ? const Center(child: Text("Belum ada foto"))
                        : Expanded(
                            child: _images.isEmpty
                                ? const Center(
                                    child: Text("Belum ada lampiran"))
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
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.info,
                      animType: AnimType.rightSlide,
                      title: 'Konfirmasi',
                      desc: 'Apakah Anda yakin ingin menyimpan data ini?',
                      btnCancelOnPress: () {},
                      btnOkOnPress: () async {
                        try {
                          setState(() {
                            isLoading = true;
                          });
                          final sportData = AktivitasModel(
                            submitDate: DateTime.now().toString(),
                            status: 0,
                            nama: 'nama',
                            nik: 'nik',
                            lampiran: '',
                            tanggal: DateTime.now().toString(),
                            lokasi: lokasiAktif,
                            namaOlahraga: widget.sportModel.nama ?? '',
                            totalWaktu: widget.timer,
                            latitude: _currentLocation?.latitude ?? 0.0,
                            longitude: _currentLocation?.longitude ?? 0.0,
                            foto: _images.isNotEmpty ? _images.first.path : '',
                          );

                          final hasInternet = await checkInternetAccess();

                          if (!hasInternet) {
                            await HiveService.saveWorkoutData(sportData);
                            notifikasiLocal('Data disimpan secara offline');
                            context.pushReplacementNamed('home');
                            ref.refresh(homePageProvider.notifier);
                            ref.watch(homePageProvider.notifier).jumpToPage(0);
                          } else {
                            await CoreService(context)
                                .uploadAktifitas(sportData, context);
                          }
                        } finally {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                    ).show();
                  }, primaryColor),
                ),
              ],
            ),
            floatingActionButton: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  heroTag: "cameraFab",
                  child: const Icon(Icons.camera_alt, color: Colors.black),
                  onPressed: _pickImage,
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: "attachmentFab",
                  child: const Icon(Icons.attachment, color: Colors.black),
                  onPressed: _pickAttachment,
                ),
              ],
            ),
          );
  }
}

class FullScreenMapDialog extends StatefulWidget {
  final LatLng? currentLocation;
  final LatLng? destinationLocation;

  const FullScreenMapDialog(
      {Key? key, this.currentLocation, this.destinationLocation})
      : super(key: key);

  @override
  State<FullScreenMapDialog> createState() => _FullScreenMapDialogState();
}

class _FullScreenMapDialogState extends State<FullScreenMapDialog> {
  late final MapController _dialogMapController;

  @override
  void initState() {
    super.initState();
    _dialogMapController =
        MapController(); // Separate MapController for the dialog
    // Move the map to the current location after the dialog is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.currentLocation != null) {
        _dialogMapController.move(widget.currentLocation!, 15.0);
      }
    });
  }

  @override
  void dispose() {
    _dialogMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _dialogMapController,
      options: MapOptions(
        initialZoom: 15.0,
        initialCenter: widget.currentLocation ?? LatLng(0, 0),
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          userAgentPackageName: 'dev.fleaflet.flutter_map.example',
        ),
        if (widget.currentLocation != null &&
            widget.destinationLocation != null)
          PolylineLayer(
            polylines: [
              Polyline(
                points: [
                  widget.currentLocation!,
                  widget.destinationLocation!,
                ],
                strokeWidth: 4.0,
                color: Colors.red,
              ),
            ],
          ),
        MarkerLayer(
          markers: [
            if (widget.currentLocation != null)
              Marker(
                point: widget.currentLocation!,
                width: 50,
                height: 50,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            if (widget.destinationLocation != null)
              Marker(
                point: widget.destinationLocation!,
                width: 50,
                height: 50,
                child: const Icon(
                  Icons.flag,
                  color: Colors.red,
                  size: 40,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

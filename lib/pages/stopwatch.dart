import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:kpifit/models/olahraga.dart';
import 'package:kpifit/util/widget_appbar.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class StopWatchPage extends StatefulWidget {
  final SportModel sportModel;
  const StopWatchPage({super.key, required this.sportModel});

  @override
  StopWatchPageState createState() => StopWatchPageState();
}

class StopWatchPageState extends State<StopWatchPage> {
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  final _isHours = true;
  bool _isRunning = false;
  bool _isStopped = false;

  @override
  void dispose() {
    _stopWatchTimer.dispose();
    super.dispose();
  }

  String? timer;
  double lat = 0;
  double long = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildGradientAppBar(context, 'Timer'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<int>(
              stream: _stopWatchTimer.rawTime,
              initialData: _stopWatchTimer.rawTime.value,
              builder: (context, snap) {
                final value = snap.data!;
                final displayTime =
                    StopWatchTimer.getDisplayTime(value, hours: _isHours);

                final minutes = (value ~/ 60000);
                final seconds = ((value % 60000) ~/ 1000);

                timer = '$minutes Menit $seconds Detik';

                return Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 300,
                      height: 300,
                      child: CircularProgressIndicator(
                        value: (value % 60000) / 60000,
                        strokeWidth: 8,
                        backgroundColor: Colors.grey[300],
                        color: Colors.blue,
                      ),
                    ),
                    Text(
                      displayTime,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!_isRunning && !_isStopped)
                  IconButton(
                    icon: const Icon(Icons.play_arrow,
                        size: 40, color: Colors.blue),
                    onPressed: () async {
                      Position position = await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high,
                      );

                      _stopWatchTimer.onStartTimer();

                      setState(() {
                        lat = position.latitude;
                        long = position.longitude;
                        _isRunning = true;
                        _isStopped = false;
                      });
                    },
                  ),
                if (_isRunning)
                  IconButton(
                    icon:
                        const Icon(Icons.pause, size: 40, color: Colors.orange),
                    onPressed: () {
                      _stopWatchTimer.onStopTimer();
                      setState(() {
                        _isRunning = false;
                        _isStopped = true;
                      });
                    },
                  ),
                if (_isStopped)
                  IconButton(
                    icon: const Icon(Icons.play_arrow,
                        size: 40, color: Colors.green),
                    onPressed: () {
                      _stopWatchTimer.onStartTimer();
                      setState(() {
                        _isRunning = true;
                        _isStopped = false;
                      });
                    },
                  ),
                const SizedBox(width: 20),
                if (!_isRunning && _stopWatchTimer.rawTime.value > 0)
                  IconButton(
                    icon: const Icon(Icons.stop, size: 40, color: Colors.red),
                    onPressed: () {
                      _stopWatchTimer.onStopTimer();
                      print(lat.toString());
                      print(long.toString());
                      context.pushReplacementNamed('map',
                          queryParameters: {
                            'timer': timer,
                            'lat': lat.toString(),
                            'long': long.toString()
                          },
                          extra: widget.sportModel);
                    },
                  ),
                const SizedBox(width: 20),
                IconButton(
                  icon:
                      const Icon(Icons.refresh, size: 40, color: Colors.green),
                  onPressed: () {
                    _stopWatchTimer.onResetTimer();
                    setState(() {
                      _isRunning = false;
                      _isStopped = false;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

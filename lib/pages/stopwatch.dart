import 'package:flutter/material.dart';
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

  @override
  void dispose() {
    _stopWatchTimer.dispose();
    super.dispose();
  }

  String? timer;
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
                IconButton(
                  icon: const Icon(Icons.play_arrow,
                      size: 40, color: Colors.blue),
                  onPressed: _stopWatchTimer.onStartTimer,
                ),
                const SizedBox(width: 20),
                IconButton(
                  icon: const Icon(Icons.stop, size: 40, color: Colors.red),
                  onPressed: () {
                    _stopWatchTimer.onStopTimer();
                    context.goNamed('map',
                        queryParameters: {'timer': timer},
                        extra: widget.sportModel);
                  },
                ),
                const SizedBox(width: 20),
                IconButton(
                  icon:
                      const Icon(Icons.refresh, size: 40, color: Colors.green),
                  onPressed: _stopWatchTimer.onResetTimer,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

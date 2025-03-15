import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kpifit/util/widget_appbar.dart';

class HelpPage extends ConsumerStatefulWidget {
  const HelpPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HelpPageState();
}

class _HelpPageState extends ConsumerState<HelpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildGradientAppBar(context, 'Help & Support'),
      body: Center(child: Text('Help & Support On Progress')),
    );
  }
}

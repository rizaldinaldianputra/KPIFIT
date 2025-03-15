import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoPag extends ConsumerStatefulWidget {
  const LogoPag({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LogoPagState();
}

class _LogoPagState extends ConsumerState<LogoPag> {
  @override
  void initState() {
    initialSeason();
    super.initState();
  }

  Future<void> initialSeason() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final String? nik = sharedPreferences.getString('nik');

    if (nik == null || nik.isEmpty) {
      if (mounted) context.goNamed('login');
    } else {
      if (mounted) context.goNamed('home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/logo.png'),
      ),
    );
  }
}

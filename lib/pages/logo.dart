import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LogoPag extends ConsumerStatefulWidget {
  const LogoPag({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LogoPagState();
}

class _LogoPagState extends ConsumerState<LogoPag> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      context.goNamed('login');
    });
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
